pipeline {
    agent any
    environment { 
        DOCKERHUB_REPO = 'sidiclaudio/the-slick-app'
        DOCKERHUB_CREDS = credentials('docker-hub-id') //fetch the creds from jenkins store
    }

    stages {
        stage('Source') {
            steps {
                echo 'Retrieving the code from github'
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/sidiclaudio/the-slick-app.git'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building the container image'
                // building our image
                sh 'docker build -t $DOCKERHUB_REPO:v$BUILD_NUMBER .'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Creating a test container'
                sh 'docker run --name "container-$BUILD_NUMBER" -t -d -p 80:80 $DOCKERHUB_REPO:v$BUILD_NUMBER'
            }
        }
        
        stage('Manual Approval') {
            steps {
                input 'Revision is needed'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'authenticating to dockerhub'
                sh 'docker login -u$DOCKERHUB_CREDS_USR -p$DOCKERHUB_CREDS_PSW'
                
                echo 'Deploy the container image to dockerhub'
                sh 'docker push $DOCKERHUB_REPO:v$BUILD_NUMBER'
                
                echo 'image $DOCKERHUB_REPO:v$BUILD_NUMBER was deployed successfuly!'
            }
        }

        stage('k8 cluster access test') {
            steps {
                echo 'test connectivity to k8 cluster'
                sh 'aws eks update-kubeconfig --region us-east-2 --name fun-eks'
                sh 'kubectl version'
            }
        }
    }
    
    post { 
        // cleaning up...
        always { 
            echo 'Remove container'
            sh 'docker stop "container-$BUILD_NUMBER"'
            sh 'docker logout'
        }
        
        success { 
            echo 'HAPPY BIRTHDAY ANJELL!!!'
        }
    }
}

