"""
Root URL configuration.

Публичный API смонтирован под /api/. Медиафайлы раздаёт Django только
в DEBUG-режиме — в продакшене этим занимается веб-сервер.
"""

import os

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.shortcuts import render
from django.urls import include, path
from django.views.generic import TemplateView

from .api import APIRootView


def _media_version(name: str) -> int:
    """mtime файла в media/ — для авто cache-busting картинок."""
    path_ = os.path.join(settings.MEDIA_ROOT, name)
    return int(os.path.getmtime(path_)) if os.path.exists(path_) else 0


def home(request):
    """Главная: пробрасываем версии фото, чтобы браузер не кэшировал старые."""
    return render(request, "index.html", {
        "bereke_v": _media_version("bereke.jpeg"),
        "povar_v": _media_version("povar.jpeg"),
    })

api_patterns = [
    # menu/categories/, menu/items/
    path("menu/", include("apps.menu.urls")),
    # branches/, branches/<id>/halls/, branches/<id>/timeslots/
    path("", include("apps.contacts.urls")),
    # reservations/
    path("", include("apps.reservations.urls")),
    # gallery/
    path("", include("apps.gallery.urls")),
]

urlpatterns = [
    path("", home, name="home"),
    path("menu/", TemplateView.as_view(template_name="menu.html"), name="menu-page"),
    path("reservation/", TemplateView.as_view(template_name="reservation.html"), name="reservation-page"),
    path("admin/", admin.site.urls),
    path("api/", APIRootView.as_view(), name="api-root"),
    path("api/", include(api_patterns)),
    path("api-auth/", include("rest_framework.urls")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# Admin branding
admin.site.site_header = "BEREKE"
admin.site.site_title = "Bereke Admin"
admin.site.index_title = "Управление рестораном"
