#!/bin/bash

cd ../Jenkins_Env_Setup/terraform
terraform init -input=false
terraform plan 
terraform apply
#terraform destroy