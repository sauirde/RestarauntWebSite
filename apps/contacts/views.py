from datetime import datetime, time as time_cls, timedelta

from django.utils import timezone
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from apps.reservations.models import Reservation

from .models import Branch
from .serializers import BranchSerializer, HallSerializer

# --- Параметры расписания бронирования ---------------------------------------
WORK_START = time_cls(11, 0)      # открытие
WORK_END = time_cls(22, 0)       # закрытие
SLOT_STEP = timedelta(minutes=15)  # шаг сетки слотов
BOOKING_DURATION = timedelta(hours=3)  # столик занимается на 3 часа


class BranchViewSet(viewsets.ReadOnlyModelViewSet):
    """
    GET /api/branches/                 — филиалы со списком залов.
    GET /api/branches/<id>/halls/      — залы конкретного филиала.
    GET /api/branches/<id>/timeslots/  — свободные слоты на дату (?date=).
    """

    serializer_class = BranchSerializer
    filterset_fields = ("city", "is_active")
    search_fields = ("address", "city__name")
    ordering_fields = ("city__name", "address")

    def get_queryset(self):
        qs = Branch.objects.select_related("city").prefetch_related("halls")
        if not self.request.user.is_staff:
            qs = qs.filter(is_active=True)
        return qs

    @action(detail=True, methods=["get"])
    def halls(self, request, pk=None):
        branch = self.get_object()
        serializer = HallSerializer(
            branch.halls.all(), many=True, context=self.get_serializer_context()
        )
        return Response(serializer.data)

    @action(detail=True, methods=["get"])
    def timeslots(self, request, pk=None):
        """Свободные стартовые слоты с шагом 15 мин (бронь = 3 часа)."""
        branch = self.get_object()

        raw_date = request.query_params.get("date")
        if not raw_date:
            return Response(
                {"date": "Обязательный параметр: ?date=YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        try:
            target_date = datetime.strptime(raw_date, "%Y-%m-%d").date()
        except ValueError:
            return Response(
                {"date": "Неверный формат даты, ожидается YYYY-MM-DD."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        if target_date < timezone.localdate():
            return Response(
                {"date": "Нельзя запрашивать слоты на прошедшую дату."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Кандидаты: старт каждые 15 мин так, чтобы 3 часа уложились до закрытия.
        candidates = []
        cursor = datetime.combine(target_date, WORK_START)
        last_start = datetime.combine(target_date, WORK_END) - BOOKING_DURATION
        now = timezone.localtime()
        while cursor <= last_start:
            # для сегодняшней даты убираем уже прошедшие слоты
            if not (target_date == now.date() and cursor.time() <= now.time()):
                candidates.append(cursor)
            cursor += SLOT_STEP

        # Активные брони филиала на эту дату → занятые интервалы.
        busy = [
            (
                datetime.combine(target_date, t),
                datetime.combine(target_date, t) + BOOKING_DURATION,
            )
            for t in branch.reservations.filter(date=target_date)
            .exclude(status=Reservation.Status.CANCELLED)
            .values_list("time", flat=True)
        ]

        def is_free(start):
            end = start + BOOKING_DURATION
            return all(not (start < b_end and b_start < end) for b_start, b_end in busy)

        available = [s.strftime("%H:%M") for s in candidates if is_free(s)]

        return Response(
            {
                "branch": branch.id,
                "date": target_date.isoformat(),
                "working_hours": f"{WORK_START:%H:%M}–{WORK_END:%H:%M}",
                "slot_step_minutes": int(SLOT_STEP.total_seconds() // 60),
                "booking_duration_hours": int(BOOKING_DURATION.total_seconds() // 3600),
                "available": available,
            }
        )
