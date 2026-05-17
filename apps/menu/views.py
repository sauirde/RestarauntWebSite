from rest_framework import viewsets

from .models import Category, MenuItem
from .serializers import CategorySerializer, MenuItemSerializer


class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """GET /api/menu/categories/ — список категорий меню."""

    queryset = Category.objects.prefetch_related("items").all()
    serializer_class = CategorySerializer
    pagination_class = None  # категорий немного — отдаём одним списком
    search_fields = ("name",)
    ordering_fields = ("order", "name")


class MenuItemViewSet(viewsets.ReadOnlyModelViewSet):
    """GET /api/menu/items/ — блюда, фильтр ?category=<id>."""

    serializer_class = MenuItemSerializer
    filterset_fields = ("category", "is_available", "is_featured")
    search_fields = ("name", "description")
    ordering_fields = ("price", "name")

    def get_queryset(self):
        qs = MenuItem.objects.select_related("category")
        # Анонимным пользователям — только доступные блюда.
        if not self.request.user.is_staff:
            qs = qs.filter(is_available=True)
        return qs
