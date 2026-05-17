#!/usr/bin/env bash
# ============================================================================
#  deploy.sh — обновление продакшена: git pull → build → migrate →
#              collectstatic → restart.
#  Запускать на сервере из корня репозитория:  ./deploy/deploy.sh
# ============================================================================
set -euo pipefail

# Переходим в корень репозитория (на уровень выше каталога скрипта).
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

COMPOSE="docker compose --env-file deploy/.env"
BRANCH="${DEPLOY_BRANCH:-main}"

log() { printf '\n\033[1;33m▶ %s\033[0m\n' "$*"; }

if [ ! -f deploy/.env ]; then
  echo "✗ Нет файла deploy/.env — скопируйте deploy/.env.example и заполните." >&2
  exit 1
fi

log "1/6 Обновление кода (git pull, ветка ${BRANCH})"
git fetch --prune origin
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

log "2/6 Сборка образа web"
$COMPOSE build web

log "3/6 Поднятие БД и приложения"
$COMPOSE up -d db
# ждём, пока БД пройдёт healthcheck
until [ "$($COMPOSE ps -q db | xargs docker inspect -f '{{.State.Health.Status}}')" = "healthy" ]; do
  echo "  …ожидание готовности PostgreSQL"
  sleep 2
done
$COMPOSE up -d web

log "4/6 Миграции базы данных"
$COMPOSE exec -T web python manage.py migrate --noinput

log "5/6 Сбор статики"
$COMPOSE exec -T web python manage.py collectstatic --noinput

log "6/6 Перезапуск web и nginx"
$COMPOSE up -d nginx
$COMPOSE restart web nginx

log "Очистка старых образов"
docker image prune -f >/dev/null || true

log "Готово. Статус сервисов:"
$COMPOSE ps
