from django.core.exceptions import ValidationError
from django.utils import timezone
from django.utils.translation import gettext_lazy as _


def validate_not_past_date(value):
    """Запрещает бронирование на прошедшую дату.

    Используется как field-валидатор (срабатывает в формах, админке и
    при вызове full_clean()).
    """
    if value < timezone.localdate():
        raise ValidationError(
            _("Нельзя бронировать столик на прошедшую дату."),
            code="past_date",
        )
