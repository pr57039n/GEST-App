FROM nginx:latest

RUN apt-get update && apt-get install -y procps

#creates static files folder on nginx so that it can serve the static content to the web browser
RUN  mkdir -p /home/app/static  