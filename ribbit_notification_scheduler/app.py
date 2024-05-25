import os

from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.date import DateTrigger
from flask.ctx import AppContext
from flask_jwt_extended import JWTManager, create_access_token, jwt_required

from database.app_db import init_db
from model.reminder_notification import ReminderNotification
from flask import Flask, request, jsonify
from datetime import datetime
from utils.date_converter import convert_date_from_client_to_local
from integration.push_notification_messaging_service import PushNotificationMessagingService
import logging

logging.basicConfig(filename='record.log', level=logging.DEBUG)

app = Flask(__name__)

__database_url = app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///scheduler.db"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY')

init_db(app)

jwt = JWTManager(app)

scheduler = BackgroundScheduler()
scheduler.add_jobstore(SQLAlchemyJobStore(url=__database_url), 'default')
scheduler.start()

push_notification_messaging_service = PushNotificationMessagingService()


@app.route(rule='/api/login', methods=['POST'])
def server_api_login():
    username = request.json.get('username')
    password = request.json.get('password')

    if username != os.getenv('RIBBIT_SELF_ACCESS_USERNAME') and password != os.getenv('MyStrPssw0rd@123'):
        return jsonify({'message': 'Unauthorized'}), 401

    access_token = create_access_token(identity=username)
    return jsonify({'access_token': access_token}), 200


@app.route('/api/test_notification', methods=['POST'])
def send_test_notification():
    json_data = request.get_json(silent=True) or {}
    user_id = json_data.get('user_device_token')

    if not user_id:
        return jsonify({'message': 'User device token was not provided'}), 400

    push_notification_messaging_service.send_notification(
        title="Test Notification",
        preview="Test Preview",
        user_id=user_id
    )

    return jsonify({'message': 'Notification has been sent'}), 200


@app.route('/api/schedule/reminder', methods=['POST'])
@jwt_required()
def schedule_reminder():
    json_data = request.get_json(silent=True) or {}

    reminder_id = json_data.get('reminder_id')
    reminder_date = json_data.get('reminder_date')
    reminder_title = json_data.get('reminder_title')
    reminder_description = json_data.get('reminder_description')
    user_id = json_data.get('user_id')

    required_fields = [
        ('reminder_id', reminder_id),
        ('reminder_date', reminder_date),
        ('reminder_title', reminder_title),
        ('reminder_description', reminder_description),
        ('user_id', user_id)
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
        user_id=user_id
    )

    __schedule_reminder(
        reminder_id=reminder_id,
        reminder_notification=reminder_notification,
        run_date=reminder_date
    )

    return jsonify({'message': 'Notification was scheduled'}), 200


def __cancel_schedule(reminder_id: str) -> None:
    if scheduler.get_job(reminder_id):
        scheduler.remove_job(reminder_id)


def __schedule_reminder(reminder_id: str, reminder_notification: ReminderNotification, run_date: datetime) -> None:
    if scheduler.get_job(reminder_id):
        scheduler.remove_job(reminder_id)

    app.logger.debug(f'Scheduled reminder {reminder_notification.title} to {run_date}')

    scheduler.add_job(
        __push_notification_job,
        args=[reminder_notification],
        id=reminder_id,
        trigger=DateTrigger(run_date=run_date)
    )


def __push_notification_job(reminder_notification: ReminderNotification) -> None:
    app.app_context().push()
    push_notification_messaging_service.send_notification(
        title=reminder_notification.title,
        preview=reminder_notification.description,
        user_id=reminder_notification.user_id
    )


if __name__ == '__main__':
    app.run()
