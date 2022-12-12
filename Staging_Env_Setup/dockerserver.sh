#!/bin/bash 

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt update
sudo apt -y install default-jre
curl -fsSL https://share.wildbook.me/4PNafRIcXKRT2K5D.tar --output cypress.tar
sudo apt -y install firefox
sudo tar -xf cypress.tar
sudo docker pull ishtaard/gest_test_nginx:1.0
sudo docker pull ishtaard/gest_test_web:1.0
sudo docker run -d -p 8000:80 ishtaard/gest_test_nginx:1.0
sudo docker run -d -p 80:8000 ishtaard/gest_test_web
sudo docker run -it \
-v $PWD:/e2e \
-w /e2e \
-e CYPRESS_baseUrl=http://172.17.0.1:8000 \
cypress/included:12.0.2 --browser firefox
