# syntax=docker/dockerfile:1
# ---------------------------------------------------------------------------
# Django (restaurant) — production image
# ---------------------------------------------------------------------------
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    DJANGO_SETTINGS_MODULE=config.settings

WORKDIR /app

# Системные зависимости: libpq для psycopg2 во время рантайма,
# netcat — для ожидания готовности БД в entrypoint.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq5 netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Зависимости отдельным слоем — лучше кэшируется.
COPY requirements.txt .
RUN pip install -r requirements.txt

# Код приложения.
COPY . .

# Каталоги под собранную статику и медиа (монтируются как volume).
RUN mkdir -p /app/staticfiles /app/media

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request,sys; \
sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8000/api/',timeout=4).status==200 else 1)" \
    || exit 1

ENTRYPOINT ["/app/deploy/entrypoint.sh"]
CMD ["gunicorn", "config.wsgi:application", \
     "--bind", "0.0.0.0:8000", \
     "--workers", "3", \
     "--timeout", "60", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]
