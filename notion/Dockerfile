FROM python:3.8-alpine

COPY requirements.txt /

RUN apk add --no-cache libffi-dev build-base openssl-dev
RUN pip install --upgrade pip
RUN pip install -r /requirements.txt

WORKDIR /app
COPY ./main.py /app

ENTRYPOINT ["python", "/app/main.py"]
