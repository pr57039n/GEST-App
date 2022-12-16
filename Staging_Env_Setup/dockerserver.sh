#!/bin/bash
curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh get-docker.sh 
sudo apt update 
sudo apt -y install default-jre
curl -fsSL https://share.wildbook.me/lmRhIVUdqSwlGfhM.tar --output cypress.tar
sudo apt -y install firefox
sudo tar -xf cypress.tar
sudo docker pull bikigrg/gest_app:latest
sudo docker run -d -p 80:8000 bikigrg/gest_app:latest
sudo docker run -it \
-v $PWD:/e2e \
-w /e2e \
-e CYPRESS_baseUrl=http://172.17.0.1:80 \
cypress/included:12.0.2 --browser firefox > cylog_$(date +%d-%m-%y);
