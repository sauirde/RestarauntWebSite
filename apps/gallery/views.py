from rest_framework import viewsets

from .models import GalleryPhoto
from .serializers import GalleryPhotoSerializer


class GalleryViewSet(viewsets.ReadOnlyModelViewSet):
    """GET /api/gallery/ — фотогалерея (анониму — только активные)."""

    serializer_class = GalleryPhotoSerializer
    ordering_fields = ("order", "created_at")
    search_fields = ("caption",)

    def get_queryset(self):
        qs = GalleryPhoto.objects.all()
        if not self.request.user.is_staff:
            qs = qs.filter(is_active=True)
        return qs
