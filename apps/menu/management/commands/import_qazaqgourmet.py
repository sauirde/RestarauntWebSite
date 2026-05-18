"""
Management command: import menu from qazaqgourmet.kz

Usage:
    python manage.py import_qazaqgourmet
    python manage.py import_qazaqgourmet --clear   # удалить старое меню перед импортом
"""

import re

import requests
from bs4 import BeautifulSoup
from django.core.management.base import BaseCommand
from django.db import transaction

from apps.menu.models import Category, MenuItem

URL = "https://qazaqgourmet.kz/menu"

# Категории из бара/вин — не импортируем в меню ресторана
SKIP_CATEGORIES = {
    "ВИННАЯ КАРТА", "БАРНАЯ КАРТА", "WINE LIST", "BAR MENU",
    "БОКАЛЬНОЕ МЕНЮ", "ШАМПАНСКОЕ", "ИГРИСТЫЕ ВИНА", "РОЗОВЫЕ ВИНА",
    "ДЕСЕРТНЫЕ ВИНА", "БЕЛЫЕ ВИНА", "КРАСНЫЕ ВИНА",
    "КОКТЕЙЛИ", "ВИСКИ", "ВОДКА", "КОНЬЯК", "БРЕНДИ", "РОМ", "ДЖИ",
    "ТЕКИЛА", "ГРАППА", "ПОРТВЕЙН", "ПИВО", "БЕЗАЛКОГОЛЬНЫЕ",
    "КОФЕ", "ЧАЙ", "SAKE", "GIN",
}


def clean_price(raw: str) -> float:
    """'5 200' → 5200.0"""
    return float(re.sub(r"[^\d]", "", raw) or "0")


def clean_name(tag) -> str:
    """Извлекает текст имени, убирая вложенные <span> с описанием."""
    return tag.get_text(" ", strip=True)


def parse_menu(html: str) -> list[dict]:
    """
    Возвращает список блюд:
    [{"category": str, "name": str, "price": float}, ...]
    """
    soup = BeautifulSoup(html, "html.parser")
    result = []
    current_category = None

    for tag in soup.find_all(True):
        # Заголовок категории
        if "t026__title" in tag.get("class", []):
            text = tag.get_text(strip=True).upper()
            if text and text not in SKIP_CATEGORIES:
                current_category = tag.get_text(strip=True).strip()
            else:
                current_category = None
            continue

        # Позиция меню
        if "js-product" in tag.get("class", []) and current_category:
            name_tag = tag.find(class_="js-product-name")
            price_tag = tag.find(class_="js-product-price")
            if not name_tag or not price_tag:
                continue
            name = clean_name(name_tag)
            price = clean_price(price_tag.get_text())
            if name and price > 0:
                result.append({
                    "category": current_category,
                    "name": name,
                    "price": price,
                })

    return result


class Command(BaseCommand):
    help = "Импортирует меню с qazaqgourmet.kz"

    def add_arguments(self, parser):
        parser.add_argument(
            "--clear",
            action="store_true",
            help="Удалить все существующие категории и блюда перед импортом",
        )

    def handle(self, *args, **options):
        self.stdout.write("Загружаю страницу меню...")
        try:
            resp = requests.get(URL, timeout=30, headers={"User-Agent": "Mozilla/5.0"})
            resp.raise_for_status()
        except requests.RequestException as e:
            self.stderr.write(f"Ошибка загрузки: {e}")
            return

        items = parse_menu(resp.text)
        if not items:
            self.stderr.write("Блюда не найдены. Возможно, структура сайта изменилась.")
            return

        self.stdout.write(f"Найдено {len(items)} позиций в {len({i['category'] for i in items})} категориях.")

        with transaction.atomic():
            if options["clear"]:
                MenuItem.objects.all().delete()
                Category.objects.all().delete()
                self.stdout.write("Старое меню удалено.")

            category_cache: dict[str, Category] = {}
            created_items = 0
            skipped_items = 0

            for order, item in enumerate(items):
                cat_name = item["category"]
                if cat_name not in category_cache:
                    cat, _ = Category.objects.get_or_create(
                        name=cat_name,
                        defaults={"order": len(category_cache) * 10},
                    )
                    category_cache[cat_name] = cat

                cat = category_cache[cat_name]
                _, created = MenuItem.objects.get_or_create(
                    category=cat,
                    name=item["name"],
                    defaults={"price": item["price"]},
                )
                if created:
                    created_items += 1
                else:
                    skipped_items += 1

        self.stdout.write(self.style.SUCCESS(
            f"Готово: добавлено {created_items} блюд, пропущено {skipped_items} (уже существуют)."
        ))
