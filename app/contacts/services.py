from fastapi import HTTPException, status
from typing import List


import app.contacts.models as models


async def create_new_contact(request, database) -> models.Contacts:
    new_contact = models.Contacts(
        id=request.id,
        first_name=request.first_name,
        last_name=request.last_name,
        number=request.number,
        notes=request.notes,
    )
    database.add(new_contact)
    database.commit()
    database.refresh(new_contact)
    return new_contact


async def get_all_contact(database) -> List[models.Contacts]:
    contacts = database.query(models.Contacts).all()
    return contacts


async def get_contact_by_id(contact_id, database):
    contact = database.query(models.Contacts).filter_by(id=contact_id).first()
    if not contact:
      raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND, detail="Contact Data Not Found !"
      )
    return contact


async def delete_contact_by_id(contact_id, database):
    contact = database.query(models.Contacts).filter_by(id=contact_id).first()
    if not contact:
      raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND, detail="Contact Data Not Found !"
      )
    database.query(models.Contacts).filter(models.Contacts.id == contact_id).delete()
    database.commit()

    return contact


async def update_contact_by_id(contact_id, request, database):
    contact = database.get(models.Contacts, contact_id)
    if not contact:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Contact Not Found !"
        )
    contact.first_name = request.first_name if request.first_name else contact.first_name
    contact.last_name = request.last_name if request.last_name else contact.last_name
    contact.number = request.number if request.number else contact.number
    contact.notes = request.notes if request.notes else contact.notes
    database.commit()
    database.refresh(contact)
    return contact
