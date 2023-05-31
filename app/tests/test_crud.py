from fastapi.testclient import TestClient
from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker

import os, sys

current_dir = os.path.dirname(os.path.realpath(__file__))
parent_dir = os.path.dirname(current_dir)
sys.path.append(parent_dir)

from db import Base, get_db
from main import app

DATABASE_USERNAME = os.environ.get("DATABASE_USERNAME")
DATABASE_PASSWORD = os.environ.get("DATABASE_PASSWORD")
DATABASE_HOST = os.environ.get("DATABASE_HOST")
DATABASE_NAME = os.environ.get("DATABASE_NAME")

SQLALCHEMY_DATABASE_URL = f"postgresql://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{DATABASE_HOST}/{DATABASE_NAME}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)
MetaData(schema="tests")

def override_get_db():
  try:
    db = TestingSessionLocal()
    yield db
  finally:
    db.close()


app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

contact_id=999
number="6287837443245"

def test_create_contact():
  response = client.post(
      "/contacts",
      json={"id": contact_id, "first_name": "Ahmad", "last_name": "Dahlan", "number": number, "notes": "lorem ipsum dolor"},
  )
  assert response.status_code == 201
  data = response.json()
  assert data["number"] == number


def test_duplicate_contact():
  response = client.post(
      "/contacts",
      json={"first_name": "Ahmad", "last_name": "Dahlan", "number": number, "notes": "lorem ipsum dolor"},
  )
  assert response.status_code == 400
  data = response.json()
  assert data["detail"] == "This contact with this number already exists in the system."


def test_update_contact():
  response = client.patch(
      f"/contacts/{contact_id}",
      json={"first_name": "Ahmad", "last_name": "Dahlan", "number": number, "notes": "Test Update"},
  )
  assert response.status_code == 200
  data = response.json()
  assert data["notes"] == "Test Update"


def test_delete_contact():
  response = client.delete(
      f"/contacts/{contact_id}"
  )
  assert response.status_code == 200
  data = response.json()
  assert data["id"] == contact_id