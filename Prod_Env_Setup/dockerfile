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

FROM python:3.9-buster

# install nginx
RUN apt-get update && apt-get install nginx vim -y --no-install-recommends
COPY nginx.default /etc/nginx/sites-available/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# copy source and install dependencies
RUN mkdir -p /opt/app
RUN mkdir -p /opt/app/pip_cache
RUN mkdir -p /opt/app/martor_demo
COPY requirements.txt start-server.sh /opt/app/
COPY .pip_cache /opt/app/pip_cache/
COPY app /opt/app/app/
WORKDIR /opt/app
RUN pip install -r requirements.txt --cache-dir /opt/app/pip_cache
RUN chown -R www-data:www-data /opt/app

# start server
EXPOSE 8020
STOPSIGNAL SIGTERM
CMD ["/opt/app/start-server.sh"]