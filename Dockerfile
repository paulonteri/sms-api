FROM python:3.6-alpine

ENV PYTHONUNBUFFERED 1 # environment variable
RUN mkdir /code
WORKDIR /code
COPY . /code/

# install psycopg2 dependencies
RUN apk update && apk add --no-cache postgresql-dev gcc python3-dev musl-dev
RUN apk add  --no-cache libressl-dev musl-dev libffi-dev
RUN apk add --no-cache zlib gcc python3-dev jpeg-dev zlib-dev

RUN pip install --no-cache-dir -r requirements.txt

ENV PORT 8080

# The maximum concurrent requests are 'workers * threads'
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 2 --timeout 0 school.wsgi:application
