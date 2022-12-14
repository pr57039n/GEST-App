pipeline{
    agent any
    environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
    stages {
        stage ('Build') {
            steps {
                sh '''#!/bin/bash
                pip install virtualenv
                virtualenv .
                source bin/activate
                pip install pip --upgrade
                cd Prod_Env_Setup
                pip install -r requirements.txt
                '''
            }
        }
        stage ('Create'){
            agent{label 'dockerAgent'}
            steps{
                dir ('Prod_Env_Setup') {
                    sh '''#!/bin/bash
                        cd Prod_Env_Setup
                        sudo docker build -t bikigrg/nginx_proxy ./nginx/
                        sudo docker build -t bikigrg/gest_app ./app/
                    '''
                } 
            }
        }
        stage ('Push'){
            agent{label 'dockerAgent'}
            steps{
                sh '''#!/bin/bash
                    sudo docker logout
                    sudo docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                    sudo docker push bikigrg/nginx_proxy:latest
                    sudo docker push bikigrg/gest_app:latest
                    '''
            }
        }
        stage('Staging') {
            agent{label 'terraformAgent'}
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('Staging_Env_Setup') {
                        sh 'terraform init'
                        sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                        sh 'terraform apply plan.tfplan'
                    }
                }
            }
        }
        stage('Sanity check') {
            steps {
                input "Does the staging environment look ok?"
            }
        }
        stage('StagingDestroy') {
            agent{label 'terraformAgent'}
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('Staging_Env_Setup') {
                        sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                    }
                }
            }
        }
        stage('Prod') {
            agent{label 'terraformAgent'}
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('Prod_Env_Setup') {
                        sh '''#!/bin/bash
                            cd ./terraform
                            terraform init
                            terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"
                            terraform apply plan.tfplan
                        '''
                    }
                }
            }
        }
        stage('ProductionDestroy') {
            agent{label 'terraformAgent'}
            steps {
                withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                    dir('Prod_Env_Setup') {
                        sh '''#!/bin/bash
                            cd terraform
                            terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"
                        '''
                    }
                }
            }
        }            
    }
}
