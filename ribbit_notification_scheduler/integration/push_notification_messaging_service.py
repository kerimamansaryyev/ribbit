from firebase_admin import initialize_app, messaging, exceptions
from flask import current_app


class PushNotificationMessagingService:
    default_app = None

    def __init__(self):
        self.default_app = initialize_app()
        print(self.default_app.project_id)

    @staticmethod
    def send_notification(title: str, preview: str, user_token: str) -> None:
        try:
            message = messaging.Message(
                notification=messaging.Notification(
                    title=title,
                    body=preview
                ),
                token=user_token
            )
            response = messaging.send(message)
            current_app.logger.info(f"Sent push notification: {message}\nResponse:{response}")
        except exceptions.FirebaseError as f_e:
            current_app.logger.exception(f"Firebase error when trying to send notification: ${f_e}")
        except ValueError as v_e:
            current_app.logger.exception(f"Invalid notification format: ${v_e}")
