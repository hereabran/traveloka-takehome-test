from sqlalchemy import String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base


class Contacts(Base):
    __tablename__ = "contacts"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    first_name: Mapped[str] = mapped_column(String(30))
    last_name: Mapped[str] = mapped_column(String(30))
    number: Mapped[str] = mapped_column(String(15))
    notes: Mapped[str] = mapped_column(Text)

    def __repr__(self) -> str:
        return f"{self.first_name} {self.last_name} - {self.number}"
