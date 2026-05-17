# Restaurant Website — Backend

Django 4.2 (LTS) + Django REST Framework + PostgreSQL.

## Стек

- **Django 4.2** + **DRF** — REST API
- **PostgreSQL** — база данных
- **django-cors-headers** — CORS для SPA-фронтенда
- **django-environ** — конфигурация через переменные окружения
- **django-filter** — фильтрация/поиск в API
- **Pillow** — обработка изображений (медиа)
- **WhiteNoise / Gunicorn** — продакшен-раздача статики и WSGI

## Структура

```
config/                # настройки проекта (settings, urls, wsgi, asgi)
apps/
  menu/                # категории и блюда
  reservations/        # бронирование столиков
  gallery/             # фотогалерея (альбомы и изображения)
  contacts/            # филиалы ресторана
media/                 # загружаемые изображения
```

## Запуск (локально)

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

cp .env.example .env          # заполните SECRET_KEY и доступ к БД

# создайте БД PostgreSQL (имя/пользователь — из .env), затем:
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

## API

Базовый префикс: `/api/` (индекс — `GET /api/`)

| Эндпоинт | Метод | Описание |
|---|---|---|
| `/api/menu/categories/` | GET | список категорий |
| `/api/menu/items/` | GET | блюда, фильтр `?category=<id>` |
| `/api/branches/` | GET | филиалы со списком залов |
| `/api/branches/<id>/halls/` | GET | залы конкретного филиала |
| `/api/branches/<id>/timeslots/?date=YYYY-MM-DD` | GET | свободные слоты (11:00–22:00, шаг 15 мин, бронь 3 ч) |
| `/api/reservations/` | POST | создать бронь (только создание) |
| `/api/gallery/` | GET | фотогалерея |

- Чтение публично; запись закрыта (брони создаются анонимно, но с троттлингом `10/hour`).
- `timeslots`: возвращаются только стартовые слоты, для которых 3-часовая бронь
  не пересекается с активными бронями филиала и укладывается до закрытия;
  для сегодняшней даты прошедшие слоты исключаются.
- `ReservationSerializer` валидирует: дата не в прошлом, `guests_count > 0`,
  телефон строго `+7XXXXXXXXXX`, а также соответствие зала филиалу и вместимости.
- Поддерживаются `?search=`, `?ordering=` и пагинация (`PAGE_SIZE=20`,
  у категорий отключена — отдаются одним списком).

Браузерный API и логин: `/api-auth/`. Админка: `/admin/`.

## Продакшен

- Установите `DEBUG=False`, задайте реальные `SECRET_KEY`, `ALLOWED_HOSTS`,
  `CORS_ALLOWED_ORIGINS`. При `DEBUG=False` автоматически включаются
  HTTPS-redirect, secure cookies и HSTS.
- `python manage.py collectstatic`
- `gunicorn config.wsgi:application`
- Медиа (`/media/`) раздаётся веб-сервером (nginx), не Django.
