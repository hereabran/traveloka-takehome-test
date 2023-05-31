from fastapi import FastAPI

app = FastAPI(title="Traveloka Take Home Test (ABran)", version="1.0.0")


@app.get("/")
def home():
    return "Hello World"
