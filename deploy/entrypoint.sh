#!/usr/bin/env bash
# Точка входа контейнера web: ждём БД, применяем миграции,
# собираем статику, затем запускаем переданную команду (gunicorn).
set -uo pipefail

echo "→ Запуск миграций..."

# --- миграции и статика --------------------------------------------------
python manage.py migrate --noinput || echo "WARNING: migrate failed, continuing anyway"
python manage.py collectstatic --noinput || echo "WARNING: collectstatic failed, continuing anyway"
python manage.py import_qazaqgourmet --clear || echo "WARNING: menu import failed, continuing anyway"

# --- запуск основного процесса ------------------------------------------
# Railway injects $PORT; fall back to 8000 for local Docker.
exec gunicorn config.wsgi:application \
    --bind "0.0.0.0:${PORT:-8000}" \
    --workers "${WEB_CONCURRENCY:-3}" \
    --timeout 60 \
    --access-logfile - \
    --error-logfile -
