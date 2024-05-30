import os

from apscheduler.jobstores.sqlalchemy import SQLAlchemyJobStore
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.date import DateTrigger
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
from model.reminder_notification import ReminderNotification
from flask import Flask, request, jsonify
from datetime import datetime

from model.user_device_token import UserDeviceToken
from utils.date_converter import convert_date_from_client_to_local
import logging
from integration.push_notification_messaging_service import PushNotificationMessagingService
from dependency.app_db import db

push_notification_messaging_service = PushNotificationMessagingService()


def create_app():
    logging.basicConfig(filename='record.log', level=logging.DEBUG)

    app_inner = Flask(__name__)

    __database_url = app_inner.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///scheduler.db"
    app_inner.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app_inner.config['FLASK_DEBUG'] = os.getenv('FLASK_DEBUG')
    app_inner.config['FLASK_ENV'] = os.getenv('FLASK_ENV')
    app_inner.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY')

    db.init_app(app_inner)

    JWTManager(app_inner)

    scheduler = BackgroundScheduler()
    with app_inner.app_context():
        scheduler.add_jobstore(SQLAlchemyJobStore(engine=db.engine), 'default')
    scheduler.start()

    @app_inner.route(rule='/api/login', methods=['POST'])
    def server_api_login():
        username = request.json.get('username')
        password = request.json.get('password')

        if username != os.getenv('RIBBIT_SELF_ACCESS_USERNAME') and password != os.getenv('MyStrPssw0rd@123'):
            return jsonify({'message': 'Unauthorized'}), 401

        access_token = create_access_token(identity=username, expires_delta=False)
        return jsonify({'access_token': access_token}), 200

    @app_inner.route(rule='/api/device_token', methods=['POST'])
    def set_device_token():
        json_data = request.get_json(silent=True) or {}
        user_id = json_data.get('user_id')
        device_token = json_data.get('device_token')

        if not user_id or not device_token:
            return jsonify({'error': 'user_id or device_token were not provided'}), 400

        with app_inner.app_context():
            user_device_token = UserDeviceToken.query.filter_by(token=device_token).first()
            if user_device_token:
                db.session.delete(user_device_token)
            db.session.merge(UserDeviceToken(external_user_id=user_id, token=device_token))
            db.session.commit()

        return jsonify({'message': 'The device token was registered'}), 200

    @app_inner.route(rule='/api/device_token', methods=['DELETE'])
    def delete_device_token():
        json_data = request.get_json(silent=True) or {}
        user_id = json_data.get('user_id')

        if not user_id:
            return jsonify({'error': 'user_id was not provided'}), 400

        with app_inner.app_context():
            user_device_token = UserDeviceToken.query.get(user_id)
            if user_device_token:
                db.session.delete(user_device_token)
                db.session.commit()

        return jsonify({'message': 'The device token was registered'}), 200

    @app_inner.route('/api/schedule/reminder', methods=['POST'])
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

        app_inner.logger.debug(f'Scheduled reminder {reminder_notification.title} to {run_date}')

        scheduler.add_job(
            __push_notification_job,
            args=[reminder_notification],
            id=reminder_id,
            trigger=DateTrigger(run_date=run_date)
        )

    return app_inner


app = create_app()


def __push_notification_job(reminder_notification: ReminderNotification) -> None:
    app.app_context().push()
    push_notification_messaging_service.send_notification(
        title=reminder_notification.title,
        preview=reminder_notification.description,
        user_id=reminder_notification.user_id
    )


if __name__ == '__main__':
    app.run()
