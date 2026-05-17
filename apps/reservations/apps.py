from django.apps import AppConfig


class ReservationsConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.reservations"
    verbose_name = "Бронирования"

    def ready(self):
        # Регистрируем обработчики сигналов.
        from . import signals  # noqa: F401
