from rest_framework import serializers

from .models import Branch, Hall


class HallSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hall
        fields = ("id", "branch", "name", "capacity", "description", "image")


class BranchSerializer(serializers.ModelSerializer):
    city_name = serializers.CharField(source="city.name", read_only=True)
    halls = HallSerializer(many=True, read_only=True)

    class Meta:
        model = Branch
        fields = (
            "id",
            "city",
            "city_name",
            "address",
            "phone",
            "email",
            "working_hours",
            "google_maps_link",
            "is_active",
            "halls",
        )
