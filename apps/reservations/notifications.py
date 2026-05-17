"""
Сервисы уведомлений о бронировании: SMS и Email.

Принципы:
- Ни один метод не бросает исключение наружу — сбой уведомления не должен
  ломать бизнес-операцию (подтверждение брони важнее доставки SMS).
- Каждая попытка SMS фиксируется в модели SMSLog (аудит/отладка).
- Тексты и шаблоны вынесены отдельно; провайдер задаётся в settings/.env.
"""

import logging

import requests
from django.conf import settings
from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.utils.html import strip_tags

from .models import SMSLog

logger = logging.getLogger("reservations.notifications")


class SMSService:
    """Отправка SMS через HTTP-API провайдера + журналирование."""

    @staticmethod
    def _confirmation_text(reservation) -> str:
        return (
            f"Здравствуйте, {reservation.first_name}! Бронь в «{reservation.branch}» "
            f"подтверждена: {reservation.date:%d.%m.%Y} в {reservation.time:%H:%M}, "
            f"зал «{reservation.hall.name}», гостей: {reservation.guests_count}. "
            f"Ждём вас!"
        )

    @staticmethod
    def _cancellation_text(reservation) -> str:
        return (
            f"Здравствуйте, {reservation.first_name}. Ваша бронь в "
            f"«{reservation.branch}» на {reservation.date:%d.%m.%Y} "
            f"{reservation.time:%H:%M} отменена. По вопросам свяжитесь с нами."
        )

    def send(self, phone: str, message: str, reservation=None) -> SMSLog:
        """Отправить SMS и записать результат в SMSLog. Не бросает исключений."""
        if not settings.SMS_ENABLED or not settings.SMS_API_URL:
            logger.info("SMS отключены — пропуск отправки на %s", phone)
            return self._log(
                phone, message, SMSLog.Status.SKIPPED,
                "SMS_ENABLED=False или SMS_API_URL пуст", reservation,
            )

        try:
            response = requests.post(
                settings.SMS_API_URL,
                json={
                    "api_key": settings.SMS_API_KEY,
                    "sender": settings.SMS_SENDER,
                    "phone": phone,
                    "text": message,
                },
                timeout=settings.SMS_TIMEOUT,
            )
            ok = response.ok
            body = response.text[:1000]
            status = SMSLog.Status.SENT if ok else SMSLog.Status.FAILED
            if ok:
                logger.info("SMS отправлено на %s", phone)
            else:
                logger.warning(
                    "SMS на %s: провайдер вернул %s", phone, response.status_code
                )
            return self._log(phone, message, status, body, reservation)
        except requests.RequestException as exc:
            logger.exception("Ошибка при отправке SMS на %s", phone)
            return self._log(
                phone, message, SMSLog.Status.FAILED, str(exc), reservation
            )

    def send_confirmation(self, reservation) -> SMSLog:
        return self.send(
            reservation.phone, self._confirmation_text(reservation), reservation
        )

    def send_cancellation(self, reservation) -> SMSLog:
        return self.send(
            reservation.phone, self._cancellation_text(reservation), reservation
        )

    @staticmethod
    def _log(phone, message, status, response, reservation) -> SMSLog:
        return SMSLog.objects.create(
            phone=phone,
            message=message,
            status=status,
            provider_response=response or "",
            reservation=reservation,
        )


class EmailService:
    """HTML-письма гостю и менеджеру (шаблоны в templates/emails/)."""

    def send_reservation_confirmation(self, reservation) -> bool:
        """Письмо гостю о подтверждении брони."""
        if not reservation.email:
            logger.info(
                "У брони #%s нет email гостя — письмо не отправлено",
                reservation.pk,
            )
            return False
        return self._send(
            subject=f"Бронь подтверждена — {reservation.branch}",
            template="emails/reservation_confirmation",
            context={"reservation": reservation},
            recipients=[reservation.email],
        )

    def send_new_reservation_to_admin(self, reservation) -> bool:
        """Уведомление менеджеру о новой/подтверждённой брони."""
        return self._send(
            subject=f"Новая бронь #{reservation.pk} — {reservation.branch}",
            template="emails/new_reservation_admin",
            context={"reservation": reservation},
            recipients=[settings.MANAGER_EMAIL],
        )

    @staticmethod
    def _send(subject, template, context, recipients) -> bool:
        try:
            html_body = render_to_string(f"{template}.html", context)
            try:
                text_body = render_to_string(f"{template}.txt", context)
            except Exception:
                text_body = strip_tags(html_body)

            email = EmailMultiAlternatives(
                subject=subject,
                body=text_body,
                from_email=settings.DEFAULT_FROM_EMAIL,
                to=recipients,
            )
            email.attach_alternative(html_body, "text/html")
            email.send(fail_silently=False)
            logger.info("Email «%s» отправлен на %s", subject, recipients)
            return True
        except Exception:
            logger.exception("Не удалось отправить email на %s", recipients)
            return False


# Готовые singleton-инстансы для импорта из сигналов/админки.
sms_service = SMSService()
email_service = EmailService()
