# FROM python:latest

# WORKDIR /app

# RUN pip install --upgrade pip
# COPY ./requirements.txt .
# RUN pip install "psycopg[binary]" 
# RUN pip install -r requirements.txt

# COPY . .
# EXPOSE 8000

# RUN python manage.py makemigrations
# ENTRYPOINT manage.py runserver

# Dockerfile

FROM python:latest

WORKDIR /app

COPY . .

RUN pip install --upgrade pip

COPY ./requirements.txt .
 
RUN pip install -r requirements.txt

EXPOSE 8000

WORKDIR /app/app

RUN python manage.py migrate

ENTRYPOINT python manage.py runserver 0.0.0.0:8000