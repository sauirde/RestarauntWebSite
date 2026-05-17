from django.core.exceptions import ValidationError
from django.core.validators import (
    MaxValueValidator,
    MinValueValidator,
    RegexValidator,
)
from django.db import models
from django.utils import timezone

from .validators import validate_not_past_date

phone_validator = RegexValidator(
    regex=r"^\+?[0-9\s\-()]{7,20}$",
    message="Введите корректный номер телефона.",
)


class Reservation(models.Model):
    """Заявка на бронирование столика в зале филиала."""

    class Status(models.TextChoices):
        PENDING = "pending", "Ожидает подтверждения"
        CONFIRMED = "confirmed", "Подтверждена"
        CANCELLED = "cancelled", "Отменена"

    branch = models.ForeignKey(
        "contacts.Branch",
        verbose_name="Филиал",
        related_name="reservations",
        on_delete=models.PROTECT,
    )
    hall = models.ForeignKey(
        "contacts.Hall",
        verbose_name="Зал",
        related_name="reservations",
        on_delete=models.PROTECT,
    )

    first_name = models.CharField("Имя", max_length=80)
    last_name = models.CharField("Фамилия", max_length=80)
    phone = models.CharField(
        "Телефон", max_length=20, validators=[phone_validator]
    )
    email = models.EmailField("Email", blank=True)

    date = models.DateField("Дата", validators=[validate_not_past_date])
    time = models.TimeField("Время")
    guests_count = models.PositiveSmallIntegerField(
        "Количество гостей",
        validators=[MinValueValidator(1), MaxValueValidator(50)],
    )
    comment = models.TextField("Комментарий", blank=True)

    status = models.CharField(
        "Статус",
        max_length=10,
        choices=Status.choices,
        default=Status.PENDING,
    )

    created_at = models.DateTimeField("Создана", auto_now_add=True)

    class Meta:
        verbose_name = "Бронирование"
        verbose_name_plural = "Бронирования"
        ordering = ("-created_at",)
        indexes = [
            models.Index(fields=("branch", "date", "status")),
        ]

    def __str__(self) -> str:
        return (
            f"{self.first_name} {self.last_name} — "
            f"{self.date} {self.time:%H:%M} ({self.get_status_display()})"
        )

    def clean(self):
        """Сквозная валидация: дата/время не в прошлом и зал из этого филиала."""
        super().clean()
        errors = {}
        today = timezone.localdate()

        if self.date:
            if self.date < today:
                errors["date"] = "Нельзя бронировать столик на прошедшую дату."
            elif (
                self.date == today
                and self.time
                and self.time <= timezone.localtime().time()
            ):
                errors["time"] = "Это время уже прошло — выберите более позднее."

        if self.branch_id and self.hall_id and self.hall.branch_id != self.branch_id:
            errors["hall"] = "Выбранный зал не принадлежит указанному филиалу."

        if self.hall_id and self.guests_count and self.guests_count > self.hall.capacity:
            errors["guests_count"] = (
                f"В зале «{self.hall.name}» максимум {self.hall.capacity} гостей."
            )

        if errors:
            raise ValidationError(errors)


class SMSLog(models.Model):
    """Журнал всех попыток отправки SMS (для аудита и отладки)."""

    class Status(models.TextChoices):
        SENT = "sent", "Отправлено"
        FAILED = "failed", "Ошибка"
        SKIPPED = "skipped", "Пропущено (SMS отключены)"

    phone = models.CharField("Телефон", max_length=20)
    message = models.TextField("Текст")
    status = models.CharField(
        "Статус", max_length=10, choices=Status.choices
    )
    provider_response = models.TextField("Ответ провайдера", blank=True)
    reservation = models.ForeignKey(
        Reservation,
        verbose_name="Бронирование",
        related_name="sms_logs",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    created_at = models.DateTimeField("Создано", auto_now_add=True)

    class Meta:
        verbose_name = "SMS-лог"
        verbose_name_plural = "SMS-логи"
        ordering = ("-created_at",)
        indexes = [
            models.Index(fields=("status", "created_at")),
        ]

    def __str__(self) -> str:
        return f"{self.phone} — {self.get_status_display()} ({self.created_at:%d.%m %H:%M})"
