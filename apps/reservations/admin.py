from django.contrib import admin, messages
from django.shortcuts import get_object_or_404, redirect
from django.urls import path, reverse
from django.utils.html import format_html

from .models import Reservation, SMSLog
from .notifications import sms_service


@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = (
        "date",
        "guest_name",
        "phone",
        "branch",
        "hall",
        "status",
        "confirm_button",
    )
    list_filter = ("status", "date", "branch")
    search_fields = ("first_name", "last_name", "phone", "email")
    date_hierarchy = "date"
    autocomplete_fields = ("branch", "hall")
    readonly_fields = ("created_at",)
    list_select_related = ("branch", "hall")
    list_per_page = 50
    actions = ("confirm_reservations", "cancel_reservations")

    # --- Кнопка «Подтвердить» прямо в строке списка --------------------------
    def get_urls(self):
        custom = [
            path(
                "<int:pk>/confirm/",
                self.admin_site.admin_view(self.process_confirm),
                name="reservations_reservation_confirm",
            ),
        ]
        return custom + super().get_urls()

    def process_confirm(self, request, pk):
        changelist = "admin:reservations_reservation_changelist"
        if not self.has_change_permission(request):
            self.message_user(request, "Недостаточно прав.", level=messages.ERROR)
            return redirect(changelist)

        reservation = get_object_or_404(Reservation, pk=pk)
        if reservation.status == Reservation.Status.CONFIRMED:
            self.message_user(
                request, "Гость уже подтверждён.", level=messages.INFO
            )
        else:
            # Меняем только статус: SMS+email гостю отправит post_save-сигнал
            # (единый источник истины, как и в массовом действии).
            reservation.status = Reservation.Status.CONFIRMED
            reservation.save(update_fields=["status"])
            self.message_user(
                request, "Гость подтверждён.", level=messages.SUCCESS
            )
        return redirect(changelist)

    @admin.display(description="Подтверждение")
    def confirm_button(self, obj):
        if obj.status == Reservation.Status.CONFIRMED:
            return format_html('<span style="color:#7f9c7f">✓ Подтверждена</span>')
        if obj.status == Reservation.Status.CANCELLED:
            return format_html('<span style="color:#9c958a">— отменена</span>')
        url = reverse("admin:reservations_reservation_confirm", args=[obj.pk])
        return format_html(
            '<a class="button" href="{}" '
            'style="background:#AEA79A;color:#0d0d0d;padding:5px 16px;'
            'border-radius:2px;font-weight:600;letter-spacing:.04em;'
            'white-space:nowrap">Подтвердить</a>',
            url,
        )

    @admin.display(description="Имя гостя", ordering="last_name")
    def guest_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

    @admin.action(description="Подтвердить выбранные брони")
    def confirm_reservations(self, request, queryset):
        # Только меняем статус: SMS и email гостю отправит сигнал
        # post_save при переходе в `confirmed` (единый источник истины).
        pending = queryset.exclude(status=Reservation.Status.CONFIRMED)
        confirmed = 0
        for reservation in pending:
            reservation.status = Reservation.Status.CONFIRMED
            reservation.save(update_fields=["status"])
            confirmed += 1

        if confirmed:
            self.message_user(
                request,
                f"Подтверждено броней: {confirmed}. "
                f"Гостям отправлены SMS и email.",
                level=messages.SUCCESS,
            )
        else:
            self.message_user(
                request,
                "Среди выбранных нет броней, ожидающих подтверждения.",
                level=messages.WARNING,
            )

    @admin.action(description="Отменить выбранные брони")
    def cancel_reservations(self, request, queryset):
        # Для отмены сигнала нет — SMS об отмене шлём здесь через сервис.
        to_cancel = queryset.exclude(status=Reservation.Status.CANCELLED)
        cancelled = 0
        for reservation in to_cancel:
            reservation.status = Reservation.Status.CANCELLED
            reservation.save(update_fields=["status"])
            sms_service.send_cancellation(reservation)
            cancelled += 1

        self.message_user(
            request,
            f"Отменено броней: {cancelled}. Гостям отправлены SMS.",
            level=messages.SUCCESS if cancelled else messages.WARNING,
        )


@admin.register(SMSLog)
class SMSLogAdmin(admin.ModelAdmin):
    """Только просмотр: журнал заполняется сервисом автоматически."""

    list_display = ("created_at", "phone", "status", "short_message", "reservation")
    list_filter = ("status", "created_at")
    search_fields = ("phone", "message")
    date_hierarchy = "created_at"
    list_select_related = ("reservation",)
    readonly_fields = (
        "phone",
        "message",
        "status",
        "provider_response",
        "reservation",
        "created_at",
    )

    @admin.display(description="Сообщение")
    def short_message(self, obj):
        return (obj.message[:60] + "…") if len(obj.message) > 60 else obj.message

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False
