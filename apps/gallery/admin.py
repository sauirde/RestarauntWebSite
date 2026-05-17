from adminsortable2.admin import SortableAdminMixin
from django.contrib import admin
from django.utils.html import format_html

from .models import GalleryPhoto


@admin.register(GalleryPhoto)
class GalleryPhotoAdmin(SortableAdminMixin, admin.ModelAdmin):
    """Фотогалерея с drag-and-drop сортировкой (поле `order`)."""

    list_display = ("preview", "caption", "is_active", "created_at")
    list_display_links = ("preview", "caption")
    list_filter = ("is_active",)
    search_fields = ("caption",)
    readonly_fields = ("preview_large", "created_at")
    fields = ("image", "preview_large", "caption", "is_active", "created_at")
    # `order` не выводим в list_editable — им управляет drag-and-drop.

    @admin.display(description="Превью")
    def preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="height:48px;width:48px;'
                'object-fit:cover;border-radius:6px;" />',
                obj.image.url,
            )
        return "—"

    @admin.display(description="Предпросмотр")
    def preview_large(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="max-height:240px;border-radius:8px;" />',
                obj.image.url,
            )
        return "Изображение не загружено"
