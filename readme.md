1. Create one bastion server using terraform
2. Install Kubectl (NOTE: You must use a kubectl version that is within one minor version difference of your Amazon EKS cluster control plane. For example, a 1.20 kubectl client works with Kubernetes 1.19, 1.20 and 1.21 clusters.)
3. Install AWS CLI and configure AWS credentials
4. Install Docker
5. Install Maven because it's a springboot application.
6. Need to clone github/bitbucket repository to bastionhost server.
7. Used mvn package or clean install command and Build get successful and convert jar into the target folder.
8. docker build --tag=manishn-aws-springboot-dp:latest .  and docker tag manishn-aws-springboot-dp:latest manishnarkhede/manishn-aws-springboot-dp:latest
9. docker push manishnarkhede/manishn-aws-springboot-dp:latest
10. Once the local testing has been done.Then do the eks setup and CI/CD Pipeline.
11. create EKS cluster using terraform .
12. Create nodegroup using terraform
13. Then start creating eks cluster –master. Choose later version EKS.
14. As best practice workernode should be on private subent.
15. Install a jenkins on server.
16. Log in to the jenkins server.
17. Create a pipeline project.
13. Write a Pipeline script use groovy.
14.  pipeline {
    agent any
    environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ManishNarkhede/springboot-hello.git']]])
            }
        }
        stage('Build Jar') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Docker Build') {
         // Build and push image with Jenkins' docker-plugin
            steps {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh 'docker build --tag=manishn-aws-springboot-dp:latest .'
                    sh 'docker tag manishn-aws-springboot-dp:latest manishnarkhede/manishn-aws-springboot-dp:latest'
                    sh 'docker push manishnarkhede/manishn-aws-springboot-dp:latest'
                }
            
                
       }
        stage('Integrate Jenkins with EKS Cluster and Deploy App') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
               ]]) {
                  //sh 'sudo su -s /bin/bash jenkins'
                  sh 'aws eks update-kubeconfig --name eks-terraform --region ap-south-1'
                  //sh 'sudo su'
                  sh  '/usr/local/bin/kubectl apply -f /var/lib/jenkins/workspace/deployment/deploy.yaml'
                  //sh 'whoiam'
               }
            }
        }
  }
}
