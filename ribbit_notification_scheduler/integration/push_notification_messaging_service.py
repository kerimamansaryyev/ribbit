import firebase_admin


class PushNotificationMessagingService:
    default_app = None

    def __init__(self):
        self.default_app = firebase_admin.initialize_app()
        print(self.default_app.project_id)
