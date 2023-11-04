pipeline {
    agent { label 'awsDeploy2' }
        stage('Test') {
            agent { label 'awsDeploy2' }
            steps {
                sh '''#!/bin/bash
                python3.7 -m venv test
                source test/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                pip install mysqlclient
                pip install pytest
                pytest --verbose --junit-xml test-reports/results.xml
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t annievlam/bankapp .'
            }
        }
        stage('Login and Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'annievlam-dockerhub', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                    sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh 'docker push annievlam/bankapp'
                }
            }
        }
     stage('Init') {
       agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform init' 
                            }
         }
    }
   }
      stage('Plan') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"' 
                            }
         }
    }
   }
      stage('Apply') {
        agent {label 'awsDeploy'}
       steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('intTerraform') {
                              sh 'terraform apply plan.tfplan' 
                            }
         }
    }
   }


        
    }
}
