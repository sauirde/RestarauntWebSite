from django.contrib import admin
from django.utils.html import format_html

from .models import Category, MenuItem


class MenuItemInline(admin.TabularInline):
    model = MenuItem
    extra = 0
    fields = ("name", "price", "is_available", "is_featured")
    show_change_link = True


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ("name", "order", "items_count")
    list_editable = ("order",)
    search_fields = ("name",)  # для autocomplete в MenuItemAdmin
    prepopulated_fields = {"slug": ("name",)}
    inlines = [MenuItemInline]

    @admin.display(description="Блюд")
    def items_count(self, obj):
        return obj.items.count()


@admin.register(MenuItem)
class MenuItemAdmin(admin.ModelAdmin):
    list_display = (
        "preview",
        "name",
        "category",
        "price",
        "is_available",
        "is_featured",
    )
    list_display_links = ("name",)
    list_filter = ("category", "is_available", "is_featured")
    list_editable = ("price", "is_available", "is_featured")
    search_fields = ("name", "description")
    autocomplete_fields = ("category",)
    list_select_related = ("category",)
    readonly_fields = ("preview_large",)
    fields = (
        "category",
        "name",
        "description",
        "price",
        "weight",
        "image",
        "preview_large",
        "is_available",
        "is_featured",
    )

    @admin.display(description="Фото")
    def preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="height:40px;width:40px;'
                'object-fit:cover;border-radius:6px;" />',
                obj.image.url,
            )
        return "—"

    @admin.display(description="Предпросмотр")
    def preview_large(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="max-height:220px;border-radius:8px;" />',
                obj.image.url,
            )
        return "Изображение не загружено"
