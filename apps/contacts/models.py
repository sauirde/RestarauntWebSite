from django.core.validators import MinValueValidator, RegexValidator
from django.db import models
from django.utils.text import slugify

phone_validator = RegexValidator(
    regex=r"^\+?[0-9\s\-()]{7,20}$",
    message="Введите корректный номер телефона.",
)


class City(models.Model):
    """Город присутствия сети (Алматы, Шымкент, Астана)."""

    name = models.CharField("Название", max_length=100, unique=True)
    slug = models.SlugField("Слаг", max_length=120, unique=True, blank=True)

    class Meta:
        verbose_name = "Город"
        verbose_name_plural = "Города"
        ordering = ("name",)

    def __str__(self) -> str:
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name, allow_unicode=True)
        super().save(*args, **kwargs)


class Branch(models.Model):
    """Филиал ресторана в конкретном городе."""

    city = models.ForeignKey(
        City,
        verbose_name="Город",
        related_name="branches",
        on_delete=models.PROTECT,
    )
    address = models.CharField("Адрес", max_length=255)
    phone = models.CharField(
        "Телефон", max_length=20, validators=[phone_validator]
    )
    email = models.EmailField("Email", blank=True)
    working_hours = models.CharField(
        "Часы работы", max_length=120, default="10:00 – 23:00"
    )
    google_maps_link = models.URLField("Ссылка на Google Maps", blank=True)
    is_active = models.BooleanField("Активен", default=True)

    class Meta:
        verbose_name = "Филиал"
        verbose_name_plural = "Филиалы"
        ordering = ("city__name", "address")
        constraints = [
            models.UniqueConstraint(
                fields=("city", "address"), name="unique_branch_address_per_city"
            )
        ]

    def __str__(self) -> str:
        return f"{self.city}, {self.address}"


class Hall(models.Model):
    """Зал внутри филиала (для бронирования столиков)."""

    branch = models.ForeignKey(
        Branch,
        verbose_name="Филиал",
        related_name="halls",
        on_delete=models.CASCADE,
    )
    name = models.CharField("Название зала", max_length=120)
    capacity = models.PositiveIntegerField(
        "Вместимость (чел.)", validators=[MinValueValidator(1)]
    )
    description = models.TextField("Описание", blank=True)
    image = models.ImageField(
        "Фото зала", upload_to="halls/", blank=True, null=True
    )

    class Meta:
        verbose_name = "Зал"
        verbose_name_plural = "Залы"
        ordering = ("branch", "name")
        constraints = [
            models.UniqueConstraint(
                fields=("branch", "name"), name="unique_hall_name_per_branch"
            )
        ]

    def __str__(self) -> str:
        return f"{self.name} — {self.branch}"
