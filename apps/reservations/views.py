from rest_framework import mixins, viewsets
from rest_framework.permissions import AllowAny
from rest_framework.throttling import ScopedRateThrottle

from .models import Reservation
from .serializers import ReservationSerializer


class ReservationViewSet(mixins.CreateModelMixin, viewsets.GenericViewSet):
    """
    POST /api/reservations/ — создать бронь.

    Доступно анонимно (клиент с сайта), но ограничено троттлингом
    (`reservation` scope) для защиты от спама. Просмотр/изменение
    броней выполняется через админку персоналом.
    """

    queryset = Reservation.objects.all()
    serializer_class = ReservationSerializer
    permission_classes = [AllowAny]
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "reservation"
