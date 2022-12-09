#!/bin/bash

cd ../Jenkins_Env_Setup/terraform
terraform destroy -auto-approve
rm -rf .terraform