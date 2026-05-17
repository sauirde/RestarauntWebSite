from django.core.validators import MinValueValidator
from django.db import models
from django.utils.text import slugify


class Category(models.Model):
    """Категория меню (Закуски, Супы, Десерты и т.д.)."""

    name = models.CharField("Название", max_length=120, unique=True)
    slug = models.SlugField("Слаг", max_length=140, unique=True, blank=True)
    order = models.PositiveIntegerField("Порядок", default=0)
    image = models.ImageField(
        "Изображение", upload_to="menu/categories/", blank=True, null=True
    )

    class Meta:
        verbose_name = "Категория"
        verbose_name_plural = "Категории"
        ordering = ("order", "name")

    def __str__(self) -> str:
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name, allow_unicode=True)
        super().save(*args, **kwargs)


class MenuItem(models.Model):
    """Блюдо в меню."""

    category = models.ForeignKey(
        Category,
        verbose_name="Категория",
        related_name="items",
        on_delete=models.PROTECT,
    )
    name = models.CharField("Название", max_length=160)
    description = models.TextField("Описание", blank=True)
    price = models.DecimalField(
        "Цена",
        max_digits=10,
        decimal_places=2,
        validators=[MinValueValidator(0)],
    )
    weight = models.PositiveIntegerField(
        "Вес/объём (г/мл)", blank=True, null=True
    )
    image = models.ImageField(
        "Изображение", upload_to="menu/items/", blank=True, null=True
    )
    is_available = models.BooleanField("В наличии", default=True)
    is_featured = models.BooleanField("Рекомендуемое", default=False)

    class Meta:
        verbose_name = "Блюдо"
        verbose_name_plural = "Блюда"
        ordering = ("category__order", "name")
        constraints = [
            models.UniqueConstraint(
                fields=("category", "name"), name="unique_item_per_category"
            )
        ]
        indexes = [
            models.Index(fields=("is_available", "is_featured")),
        ]

    def __str__(self) -> str:
        return f"{self.name} ({self.category})"
