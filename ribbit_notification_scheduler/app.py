from typing import Dict
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.date import DateTrigger
from model.reminde_notification import ReminderNotification
from flask import Flask, request, jsonify
from datetime import datetime
from utils.date_converter import convert_date_from_client_to_local
from integration.push_notification_messaging_service import PushNotificationMessagingService

app = Flask(__name__)

in_memory_notification_store: Dict[str, ReminderNotification] = dict()

scheduler = BackgroundScheduler()
scheduler.start()

push_notification_messaging_service = PushNotificationMessagingService()


@app.route('/api/schedule/reminder', methods=['POST'])
def schedule_reminder():
    json_data = request.get_json(silent=True) or {}

    reminder_id = json_data.get('reminder_id')
    reminder_date = json_data.get('reminder_date')
    reminder_title = json_data.get('reminder_title')
    reminder_description = json_data.get('reminder_description')
    user_device_token = json_data.get('user_device_token')

    required_fields = [
        ('reminder_id', reminder_id),
        ('reminder_date', reminder_date),
        ('reminder_title', reminder_title),
        ('reminder_description', reminder_description),
        ('user_device_token', user_device_token)
    ]

    for field in required_fields:
        if not field[1]:
            return jsonify({'error': f'{field[0]} is required'}), 400

    reminder_id = str(reminder_id)

    try:
        reminder_date = convert_date_from_client_to_local(
            client_date=datetime.strptime(str(reminder_date), '%Y-%m-%dT%H:%M:%S.%fZ')
        )
    except ValueError:
        return jsonify({'error': 'Invalid date format'}), 400

    reminder_notification = ReminderNotification(
        title=reminder_title,
        description=reminder_description,
        user_device_token=user_device_token
    )

    __schedule_reminder(
        reminder_id=reminder_id,
        reminder_notification=reminder_notification,
        run_date=reminder_date
    )

    return jsonify({'message': 'Notification was scheduled'}), 200


def __cancel_schedule(reminder_id: str) -> None:
    if reminder_id in in_memory_notification_store:
        scheduler.remove_job(reminder_id)


def __schedule_reminder(reminder_id: str, reminder_notification: ReminderNotification, run_date: datetime) -> None:
    if reminder_id in in_memory_notification_store:
        scheduler.remove_job(reminder_id)

    in_memory_notification_store[reminder_id] = reminder_notification

    def run_func():
        print(reminder_notification.title)

    scheduler.add_job(
        run_func,
        id=reminder_id,
        trigger=DateTrigger(run_date=run_date)
    )


if __name__ == '__main__':
    app.run()
