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
        stage('Test') {
            steps {
                sh '''#!/bin/bash
                source test3/bin/activate
                echo test
                '''
            }
        }
        stage ('Create'){
            agent{label 'dockerAgent'}
            steps{
                dir ('Prod_Env_Setup') {
                    sh '''#!/bin/bash
                        sudo docker-compose build 
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
                    sudo docker tag gestapp_container:v1 bikigrg/gestapp_container:v1 
                    sudo docker tag gestapp_nginx_container:latest bikigrg/gestapp_nginx_container:latest
                    sudo docker push bikigrg/gestapp_container:latest
                    sudo docker push bikigrg/gestapp_nginx_container:latest
                '''
            }
        }

        // stage ('Create'){
        //   agent{label 'docker-agent'}
        //   steps{
        //       sh '''#!/bin/bash
        //           sudo docker build -t url_shortener:v1 .
        //       '''
        //   }
        // }
    }
}
        // stage('Test') {
        //     steps {
        //         // sh '''#!/bin/bash
        //         // source test3/bin/activate
        //         // py.test --verbose --junit-xml test-reports/results.xml
        //         // '''
        //     }
        //     // post {
        //     //     always {
        //     //         junit 'test-reports/results.xml'
        //     //     }
        //     // }
        // }
        
        // stage ('Create'){
        //     // agent{label 'dockerAgent'}
        //     steps{
        //         sh '''#!/bin/bash
        //             sudo docker build -t url_shortener:v1 .
        //         '''
        //     }
        // }
        // stage ('Push'){
        //     agent{label 'dockerAgent'}
        //     // steps{
        //     //     sh '''#!/bin/bash
        //     //         sudo docker logout
        //     //         sudo docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
        //     //         sudo docker tag url_shortener:v1 bikigrg/url_shortener:v1
        //     //         sudo docker push bikigrg/url_shortener:v1
        //     //     '''
        //     // }
        // }
        // stage ('Deploy'){
        //     agent{label 'terraformAgent'}
        //     // steps {
        //     //     withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
        //     //             string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
        //     //         dir('intTerraform') {
        //     //             // sh '''#!/bin/bash
        //     //             // wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
        //     //             // echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        //     //             // sudo apt update && sudo apt install terraform
        //     //             // '''
        //     //             // sh 'terraform init'
        //     //             // sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
        //     //             // sh 'terraform apply plan.tfplan'
        //     //             sh 'terraform destroy -auto-approve -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
        //     //         }
        //     //     }
        //     // }
        // }


