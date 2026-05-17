from django.contrib import admin
from django.utils.html import format_html

from .models import Branch, City, Hall


class HallInline(admin.TabularInline):
    model = Hall
    extra = 0
    fields = ("name", "capacity", "description")
    show_change_link = True


@admin.register(City)
class CityAdmin(admin.ModelAdmin):
    list_display = ("name", "slug", "branches_count")
    search_fields = ("name",)  # нужно для autocomplete в BranchAdmin
    prepopulated_fields = {"slug": ("name",)}

    @admin.display(description="Филиалов")
    def branches_count(self, obj):
        return obj.branches.count()


@admin.register(Branch)
class BranchAdmin(admin.ModelAdmin):
    list_display = ("address", "city", "phone", "is_active")
    list_filter = ("city", "is_active")
    list_editable = ("is_active",)
    search_fields = ("address",)
    autocomplete_fields = ("city",)
    list_select_related = ("city",)
    inlines = [HallInline]
    fieldsets = (
        (None, {"fields": ("city", "address", "is_active")}),
        ("Контакты", {"fields": ("phone", "email", "working_hours")}),
        ("Карта", {"fields": ("google_maps_link",)}),
    )


@admin.register(Hall)
class HallAdmin(admin.ModelAdmin):
    list_display = ("name", "branch", "capacity", "preview")
    list_filter = ("branch__city", "branch")
    search_fields = ("name", "branch__address")  # для autocomplete брони
    autocomplete_fields = ("branch",)
    list_select_related = ("branch", "branch__city")

    @admin.display(description="Фото")
    def preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="height:40px;border-radius:4px;" />',
                obj.image.url,
            )
        return "—"
