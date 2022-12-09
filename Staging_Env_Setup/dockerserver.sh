#!/bin/bash 

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt update
sudo apt -y install default-jre