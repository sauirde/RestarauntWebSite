from rest_framework import serializers

from .models import GalleryPhoto


class GalleryPhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = GalleryPhoto
        fields = ("id", "image", "caption", "order", "is_active", "created_at")
        read_only_fields = ("created_at",)
