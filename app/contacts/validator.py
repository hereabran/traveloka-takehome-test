from typing import Optional

from sqlalchemy.orm import Session

from app.contacts.models import Contacts


async def verify_number_exist(number: str, db_session: Session) -> Optional[Contacts]:
    return db_session.query(Contacts).filter(Contacts.number == number).first()
