from fastapi import APIRouter, Depends, status, Response, HTTPException
from sqlalchemy.orm import Session

from typing import List

import app.db as db

import app.contacts.schema as schema
import app.contacts.services as services
import app.contacts.validator as validator

router = APIRouter(tags=["contacts"], prefix="/contacts")


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_contact(
    request: schema.ContactBase, database: Session = Depends(db.get_db)
):
    contact = await validator.verify_number_exist(request.number, database)

    if contact:
        raise HTTPException(
            status_code=400,
            detail="This contact with this number already exists in the system.",
        )

    new_contact = await services.create_new_contact(request, database)
    return new_contact


@router.get("", response_model=List[schema.ContactBase])
async def get_all_contact(database: Session = Depends(db.get_db)):
    return await services.get_all_contact(database)


@router.get(
    "/{contact_id}", status_code=status.HTTP_200_OK, response_model=schema.ContactBase
)
async def get_contact_by_id(contact_id: int, database: Session = Depends(db.get_db)):
    return await services.get_contact_by_id(contact_id, database)


@router.delete(
    "/{contact_id}", status_code=status.HTTP_200_OK, response_model=schema.ContactBase
)
async def delete_contact_by_id(contact_id: int, database: Session = Depends(db.get_db)):
    return await services.delete_contact_by_id(contact_id, database)


@router.patch(
    "/{contact_id}", status_code=status.HTTP_200_OK, response_model=schema.ContactBase
)
async def update_contact_by_id(
    contact_id: int,
    request: schema.ContactUpdate,
    database: Session = Depends(db.get_db),
):
    return await services.update_contact_by_id(contact_id, request, database)
