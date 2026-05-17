"""Корневой индекс API: точка входа со ссылками на все разделы."""

from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.reverse import reverse
from rest_framework.views import APIView


class APIRootView(APIView):
    """GET /api/ — карта доступных эндпоинтов."""

    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        def url(name):
            return reverse(name, request=request)

        branches = url("branch-list")
        return Response(
            {
                "menu": {
                    "categories": url("category-list"),
                    "items": url("menuitem-list"),
                },
                "branches": branches,
                "branch_halls": f"{branches}<id>/halls/",
                "branch_timeslots": f"{branches}<id>/timeslots/?date=YYYY-MM-DD",
                "reservations": url("reservation-list"),
                "gallery": url("gallery-list"),
            }
        )
