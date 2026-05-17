from rest_framework import serializers

from .models import Category, MenuItem


class CategorySerializer(serializers.ModelSerializer):
    items_count = serializers.IntegerField(source="items.count", read_only=True)

    class Meta:
        model = Category
        fields = ("id", "name", "slug", "order", "image", "items_count")


class MenuItemSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source="category.name", read_only=True)

    class Meta:
        model = MenuItem
        fields = (
            "id",
            "category",
            "category_name",
            "name",
            "description",
            "price",
            "weight",
            "image",
            "is_available",
            "is_featured",
        )
