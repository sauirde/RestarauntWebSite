"""
Сигналы бронирования.

- Новая бронь  → уведомление менеджеру (email).
- Переход статуса в `confirmed` → SMS + email гостю.

Отправка обёрнута в transaction.on_commit: уведомления уходят только
после успешного коммита, чтобы не слать SMS при откате транзакции.
"""

import logging

from django.db import transaction
from django.db.models.signals import post_save, pre_save
from django.dispatch import receiver

from .models import Reservation
from .notifications import email_service, sms_service

logger = logging.getLogger("reservations.signals")


@receiver(pre_save, sender=Reservation)
def capture_previous_status(sender, instance, **kwargs):
    """Запоминаем прежний статус из БД, чтобы поймать именно переход."""
    if instance.pk:
        instance._previous_status = (
            sender.objects.filter(pk=instance.pk)
            .values_list("status", flat=True)
            .first()
        )
    else:
        instance._previous_status = None


@receiver(post_save, sender=Reservation)
def notify_on_reservation_change(sender, instance, created, **kwargs):
    if created:
        transaction.on_commit(
            lambda: email_service.send_new_reservation_to_admin(instance)
        )
        return

    previous = getattr(instance, "_previous_status", None)
    became_confirmed = (
        instance.status == Reservation.Status.CONFIRMED
        and previous != Reservation.Status.CONFIRMED
    )
    if became_confirmed:
        logger.info(
            "Бронь #%s перешла в confirmed — отправка уведомлений", instance.pk
        )

        def _dispatch():
            sms_service.send_confirmation(instance)
            email_service.send_reservation_confirmation(instance)

        transaction.on_commit(_dispatch)
