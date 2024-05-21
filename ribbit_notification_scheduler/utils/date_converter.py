from datetime import datetime
from pytz import timezone
from tzlocal import get_localzone_name


def convert_date_from_client_to_local(client_date: datetime) -> datetime:
    from_zone = timezone('UTC')
    to_zone = timezone(get_localzone_name())
    reminder_date = client_date.replace(tzinfo=from_zone)
    return reminder_date.astimezone(to_zone)
