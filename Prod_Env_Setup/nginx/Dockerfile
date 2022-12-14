FROM nginx:latest

RUN apt-get update && apt-get install -y procps
COPY ./conf.d/default.conf /etc/nginx/nginx.conf 
#Added COPY ./conf.d/default.conf /etc/nginx/nginx.conf
#creates static files folder on nginx so that it can serve the static content to the web browser
#RUN  mkdir -p /home/app/static  
#WORKDIR  /home/app/static
#COPY ./static/ .