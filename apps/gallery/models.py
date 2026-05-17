from django.db import models


class GalleryPhoto(models.Model):
    """Фотография в галерее сайта."""

    image = models.ImageField("Изображение", upload_to="gallery/%Y/%m/")
    caption = models.CharField("Подпись", max_length=200, blank=True)
    order = models.PositiveIntegerField("Порядок", default=0)
    is_active = models.BooleanField("Активно", default=True)

    created_at = models.DateTimeField("Загружено", auto_now_add=True)

    class Meta:
        verbose_name = "Фото галереи"
        verbose_name_plural = "Фотогалерея"
        # Порядок задаётся вручную drag-and-drop в админке (adminsortable2).
        ordering = ("order",)
        indexes = [
            models.Index(fields=("is_active", "order")),
        ]

    def __str__(self) -> str:
        return self.caption or f"Фото #{self.pk}"
