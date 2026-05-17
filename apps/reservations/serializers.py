import re

from django.utils import timezone
from rest_framework import serializers

from .models import Reservation

PHONE_RE = re.compile(r"^\+7\d{10}$")


class ReservationSerializer(serializers.ModelSerializer):
    branch_name = serializers.CharField(source="branch.__str__", read_only=True)
    hall_name = serializers.CharField(source="hall.name", read_only=True)

    class Meta:
        model = Reservation
        fields = (
            "id",
            "branch",
            "branch_name",
            "hall",
            "hall_name",
            "first_name",
            "last_name",
            "phone",
            "email",
            "date",
            "time",
            "guests_count",
            "comment",
            "status",
            "created_at",
        )
        # Статус назначает только персонал, не клиент при создании брони.
        read_only_fields = ("status", "created_at")

    # --- Полевая валидация (требования ТЗ) -------------------------------
    def validate_date(self, value):
        if value < timezone.localdate():
            raise serializers.ValidationError(
                "Нельзя бронировать столик на прошедшую дату."
            )
        return value

    def validate_guests_count(self, value):
        if value <= 0:
            raise serializers.ValidationError(
                "Количество гостей должно быть больше нуля."
            )
        return value

    def validate_phone(self, value):
        normalized = value.strip()
        if not PHONE_RE.match(normalized):
            raise serializers.ValidationError(
                "Телефон должен быть в формате +7XXXXXXXXXX (12 символов)."
            )
        return normalized

    # --- Сквозная валидация (целостность брони) -------------------------
    def validate(self, attrs):
        date = attrs.get("date")
        time = attrs.get("time")
        branch = attrs.get("branch")
        hall = attrs.get("hall")
        guests = attrs.get("guests_count")

        if (
            date == timezone.localdate()
            and time
            and time <= timezone.localtime().time()
        ):
            raise serializers.ValidationError(
                {"time": "Это время уже прошло — выберите более позднее."}
            )

        if branch and hall and hall.branch_id != branch.id:
            raise serializers.ValidationError(
                {"hall": "Выбранный зал не принадлежит указанному филиалу."}
            )

        if hall and guests and guests > hall.capacity:
            raise serializers.ValidationError(
                {
                    "guests_count": (
                        f"В зале «{hall.name}» максимум {hall.capacity} гостей."
                    )
                }
            )

        return attrs
