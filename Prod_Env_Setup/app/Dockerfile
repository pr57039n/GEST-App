FROM python:latest

WORKDIR /app

COPY . .

RUN pip install --upgrade pip

COPY ./requirements.txt .

RUN pip install gunicorn
 
RUN pip install -r requirements.txt

COPY . .

#EXPOSE 8000

#WORKDIR /app/app

#RUN python manage.py migrate

#ENTRYPOINT python manage.py runserver 0.0.0.0:8000