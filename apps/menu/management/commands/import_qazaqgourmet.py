"""
Management command: import menu from qazaqgourmet.kz

Usage:
    python manage.py import_qazaqgourmet
    python manage.py import_qazaqgourmet --clear   # удалить старое меню перед импортом
"""

import re

import requests
from bs4 import BeautifulSoup
from django.core.files.base import ContentFile
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
    return tag.get_text(" ", strip=True)


def get_image_url(product_tag) -> str | None:
    """Извлекает URL полноразмерной картинки из блока товара Tilda."""
    # Приоритет: data-original (полный размер), data-src, src на img
    img = product_tag.find("img")
    if img:
        url = img.get("data-original") or img.get("data-src")
        if url and url.startswith("http"):
            return url
        # src может быть thumbnail — берём только если не resize
        src = img.get("src", "")
        if src.startswith("http") and "resize" not in src:
            return src

    # Tilda кладёт полный URL в data-original на div с background-image
    for div in product_tag.find_all("div"):
        url = div.get("data-original") or div.get("data-src")
        if url and url.startswith("http"):
            return url
        style = div.get("style", "")
        m = re.search(
            r"background-image:\s*url\(['\"]?(https?://[^'\"\)]+)['\"]?\)", style
        )
        if m and "resize" not in m.group(1):
            return m.group(1)

    return None


def download_image(url: str) -> ContentFile | None:
    try:
        resp = requests.get(url, timeout=15, headers={"User-Agent": "Mozilla/5.0"})
        resp.raise_for_status()
        return ContentFile(resp.content)
    except Exception:
        return None


def parse_menu(html: str) -> list[dict]:
    """
    Возвращает список блюд:
    [{"category": str, "name": str, "price": float, "image_url": str|None}, ...]
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
                    "image_url": get_image_url(tag),
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
            images_saved = 0

            for item in items:
                cat_name = item["category"]
                if cat_name not in category_cache:
                    cat, _ = Category.objects.get_or_create(
                        name=cat_name,
                        defaults={"order": len(category_cache) * 10},
                    )
                    category_cache[cat_name] = cat

                cat = category_cache[cat_name]
                menu_item, created = MenuItem.objects.get_or_create(
                    category=cat,
                    name=item["name"],
                    defaults={"price": item["price"]},
                )
                if created:
                    created_items += 1
                else:
                    skipped_items += 1

                # Скачиваем фото если его ещё нет
                if item["image_url"] and not menu_item.image:
                    content = download_image(item["image_url"])
                    if content:
                        filename = item["image_url"].split("/")[-1].split("?")[0] or "photo.jpg"
                        if "." not in filename:
                            filename += ".jpg"
                        menu_item.image.save(filename, content, save=True)
                        images_saved += 1

        self.stdout.write(self.style.SUCCESS(
            f"Готово: добавлено {created_items} блюд, пропущено {skipped_items} (уже существуют), "
            f"скачано {images_saved} фото."
        ))
