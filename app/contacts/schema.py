from typing import Optional, List
from pydantic import BaseModel


class ContactBase(BaseModel):
    id: Optional[int]
    first_name: str
    last_name: str
    number: str
    notes: str

    class Config:
        orm_mode = True


class ContactUpdate(BaseModel):
    first_name: Optional[str]
    last_name: Optional[str]
    number: Optional[str]
    notes: Optional[str]

    class Config:
        orm_mode = True


class ContactList(BaseModel):
    data: List[ContactBase]
