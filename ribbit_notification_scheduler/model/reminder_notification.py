class ReminderNotification:
    title = ""
    description = ""
    user_id = ""

    def __init__(self, title, description, user_id):
        self.update_data(title, description, user_id)

    def update_data(self, title, description, user_id):
        self.title = title
        self.description = description
        self.user_id = user_id
