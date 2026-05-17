# Деплой Bereke на Ubuntu-сервер (Docker)

Стек: **Django (gunicorn) + PostgreSQL + nginx** в Docker Compose.
nginx терминирует запросы, отдаёт `/static/` и `/media/` напрямую с диска,
остальное (`/`, `/api/`, `/admin/`, `/api-auth/`) проксирует в gunicorn.

```
[ Интернет ] → :80 nginx ──/static,/media──→ том на диске
                        └──всё остальное──→ web (gunicorn:8000) → db (postgres)
```

## Файлы

| Файл | Назначение |
|---|---|
| `Dockerfile` | образ Django (python:3.12-slim, non-root, gunicorn, healthcheck) |
| `docker-compose.yml` | сервисы `db`, `web`, `nginx`, тома, сеть |
| `deploy/entrypoint.sh` | ждёт БД → `migrate` → `collectstatic` → gunicorn |
| `deploy/nginx.conf` | reverse-proxy + статика/медиа + gzip + кэш |
| `deploy/.env.example` | шаблон всех переменных окружения |
| `deploy/deploy.sh` | обновление: git pull → build → migrate → collectstatic → restart |

## 1. Подготовка сервера (Ubuntu 22.04+)

```bash
sudo apt update && sudo apt -y upgrade
# Docker Engine + compose plugin
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"     # перелогиниться после этого
```

## 2. Код и переменные окружения

```bash
git clone <repo-url> /opt/bereke && cd /opt/bereke
cp deploy/.env.example deploy/.env
nano deploy/.env          # заполнить SECRET_KEY, пароли, домен, SMTP, SMS
```

Минимум, что обязательно поменять в `deploy/.env`:
- `SECRET_KEY` — случайная строка ≥50 символов
  (`python -c "import secrets;print(secrets.token_urlsafe(64))"`)
- `POSTGRES_PASSWORD` и тот же пароль внутри `DATABASE_URL`
- `ALLOWED_HOSTS`, `CORS_ALLOWED_ORIGINS`, `CSRF_TRUSTED_ORIGINS` — ваш домен
- SMTP- и SMS-доступы

> **TLS ещё не настроен?** Оставьте `SECURE_SSL_REDIRECT=False`
> (и `*_COOKIE_SECURE=False`), иначе будет бесконечный редирект на https.
> После выпуска сертификатов верните `True`.

## 3. Первый запуск

```bash
docker compose --env-file deploy/.env up -d --build
```

`entrypoint.sh` сам дождётся PostgreSQL, применит миграции и соберёт
статику. Создайте администратора:

```bash
docker compose --env-file deploy/.env exec web python manage.py createsuperuser
```

Проверка: `http://<домен>/` — главная, `/admin/` — админка,
`/api/` — корень API.

## 4. Обновление (CI/деплой новой версии)

```bash
./deploy/deploy.sh
```

Скрипт: `git pull` (ветка из `DEPLOY_BRANCH`, по умолчанию `main`) →
`docker compose build web` → поднятие БД (ждёт healthcheck) →
`migrate` → `collectstatic` → рестарт `web` и `nginx` → очистка
старых образов.

## 5. HTTPS (рекомендуется)

Вариант — Let's Encrypt на хосте + проброс сертификатов в контейнер nginx:

```bash
sudo apt -y install certbot
sudo certbot certonly --standalone -d example.com -d www.example.com
```

Затем в `docker-compose.yml` открыть порт `443:443` и смонтировать
`/etc/letsencrypt:/etc/letsencrypt:ro` в сервис `nginx`,
раскомментировать `server { listen 443 ... }` в `deploy/nginx.conf`,
вернуть `SECURE_SSL_REDIRECT=True` в `deploy/.env` и
`docker compose up -d`.

## Эксплуатация

```bash
docker compose --env-file deploy/.env ps                 # статус
docker compose --env-file deploy/.env logs -f web         # логи Django
docker compose --env-file deploy/.env exec web python manage.py shell

# Бэкап БД
docker compose --env-file deploy/.env exec -T db \
  pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" > backup_$(date +%F).sql

# Восстановление
cat backup.sql | docker compose --env-file deploy/.env exec -T db \
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
```

## Замечания по конфигурации

- `settings.py` теперь читает **`DATABASE_URL`** (через `django-environ`);
  при его отсутствии — fallback на раздельные `DB_*` (локальная разработка).
- Статика собирается `collectstatic` в том `static_volume`
  (`/app/staticfiles` ↔ `/vol/static`), медиа — `media_volume`;
  nginx раздаёт их напрямую, минуя Django.
- Прод-флаги безопасности (`SECURE_SSL_REDIRECT`, HSTS, secure-cookies)
  включаются при `DEBUG=False` и переопределяются через `.env`.
- `deploy/.env` **не коммитить** — он в `.gitignore` (`.env`).
