from dependency.app_db import db


class UserDeviceToken(db.Model):
    __tablename__ = 'user_device_token'
    external_user_id = db.Column(db.Integer, primary_key=True, autoincrement=False)
    token = db.Column(db.String(255), unique=True, nullable=False)

    def __repr__(self):
        return f'<Token of {self.external_user_id}>'
