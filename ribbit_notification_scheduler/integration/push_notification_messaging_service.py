import sqlalchemy
from firebase_admin import initialize_app, messaging, exceptions
from flask import current_app
from model.user_device_token import UserDeviceToken
from dependency.app_db import db


class PushNotificationMessagingService:
    default_app = None

    def __init__(self):
        self.default_app = initialize_app()

    @staticmethod
    def send_notification(title: str, preview: str, user_id: str) -> None:
        with current_app.app_context():
            try:
                device_token = db.session.get(UserDeviceToken, user_id)
            except sqlalchemy.orm.exc.ObjectDeletedError:
                current_app.logger.exception(f"Token for the user {user_id} is deleted")
                return
        if not device_token:
            current_app.logger.exception(f"Token for the user{user_id} was not found")
            return
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=preview
                ),
                token=device_token.token
            )
            response = messaging.send(message)
            current_app.logger.info(f"Sent push notification: {message}\nResponse:{response}")
        except exceptions.FirebaseError as f_e:
            current_app.logger.exception(f"Firebase error when trying to send notification: ${f_e}")
        except ValueError as v_e:
            current_app.logger.exception(f"Invalid notification format: ${v_e}")
