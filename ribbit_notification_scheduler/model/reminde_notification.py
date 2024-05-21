from typing import Type


class ReminderNotification:
    title = ""
    description = ""
    user_device_token = ""

    def __init__(self, title, description, user_device_token):
        self.update_data(title, description, user_device_token)

    def update_data(self, title, description, user_device_token):
        self.title = title
        self.description = description
        self.user_device_token = user_device_token
