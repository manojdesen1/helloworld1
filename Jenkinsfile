pipeline {
  agent any

  tools {
    jdk 'java'
    maven 'maven'
  }
  
  environment {

      sonar_url = 'http://3.129.7.203:9000'
      sonar_username = 'admin'
      sonar_password = 'admin'
      nexus_url = '3.129.7.203:8081'
      artifact_version = '6.0.0'
     AWS_ACCOUNT_ID="405767789238"
     AWS_DEFAULT_REGION="us-east-1"
     IMAGE_REPO_NAME="dcoker.demo"
    IMAGE_TAG="latest"
    REPOSITORY_URI= "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"

 }
  
stages {
    stage('Git checkout'){
      steps {
        git branch: 'main',
        url: 'https://github.com/manojdesen1/helloworld1.git'
      }
    }
    stage('Maven build'){
      steps {
        sh 'mvn clean install'
      }
    }
  stage ('Sonarqube Analysis'){
           steps {
           withSonarQubeEnv('sonarqube') {
           sh '''
           mvn -e -B sonar:sonar -Dsonar.java.source=1.8 -Dsonar.host.url="${sonar_url}" -Dsonar.login="${sonar_username}" -Dsonar.password="${sonar_password}" -Dsonar.sourceEncoding=UTF-8
           '''
           }
         }
      } 
   stage ('Publish Artifact') {
        steps {
          nexusArtifactUploader artifacts: [[artifactId: 'hello-world-war', classifier: '', file: "target/hello-world-war-1.0.0.war", type: 'war']], credentialsId: 'nex-cred', groupId: 'com.efsavage', nexusUrl: "${nexus_url}", nexusVersion: 'nexus3', protocol: 'http', repository: 'release', version: "${artifact_version}"
        }
      }
  stage ('login') {
    steps {
      sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --passwword-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
    }
  }
  stage('pushing') {
    steps {
      script{
        sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
        SH "docker push ${AWS_ACCOUNT_ID}:dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
      }
    }
  }
    
  
}
}
