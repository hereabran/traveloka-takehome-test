FROM python:3.9

ARG PORT
ENV PORT $PORT

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

CMD ["/bin/bash", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", $PORT, "--proxy-headers"]