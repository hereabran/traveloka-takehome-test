from fastapi import FastAPI, Request, status
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from collections import defaultdict

from app.contacts import router as contact_router

app = FastAPI(title="Traveloka Take Home Test (ABran)", version="1.0.0")

@app.get("/")
def home():
    return "Hello World"


app.include_router(contact_router.router)
