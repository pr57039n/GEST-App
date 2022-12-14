FROM python:latest

WORKDIR /app

RUN pip install --upgrade pip

COPY ./requirements.txt .

RUN pip install gunicorn
 
RUN pip install -r requirements.txt

COPY . .

EXPOSE 8000

#WORKDIR ./app

RUN python manage.py migrate

ENTRYPOINT gunicorn student_management_system.wsgi:application --bind 0.0.0.0:8000