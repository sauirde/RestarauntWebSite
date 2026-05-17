#!/usr/bin/env bash
# Точка входа контейнера web: ждём БД, применяем миграции,
# собираем статику, затем запускаем переданную команду (gunicorn).
set -euo pipefail

# --- ожидание PostgreSQL -------------------------------------------------
# Skip nc wait if DB_HOST is not explicitly set (e.g. Railway uses DATABASE_URL).
DB_HOST="${DB_HOST:-}"
DB_PORT="${DB_PORT:-5432}"

if [ -n "$DB_HOST" ]; then
  echo "→ Ожидание базы данных ${DB_HOST}:${DB_PORT} ..."
  until nc -z "$DB_HOST" "$DB_PORT"; do
    sleep 1
  done
  echo "✓ База доступна"
else
  echo "→ DB_HOST не задан, пропускаем ожидание БД (Railway/managed DB)"
fi

# --- миграции и статика --------------------------------------------------
python manage.py migrate --noinput
python manage.py collectstatic --noinput

# --- запуск основного процесса ------------------------------------------
# Railway injects $PORT; fall back to 8000 for local Docker.
exec gunicorn config.wsgi:application \
    --bind "0.0.0.0:${PORT:-8000}" \
    --workers "${WEB_CONCURRENCY:-3}" \
    --timeout 60 \
    --access-logfile - \
    --error-logfile -
