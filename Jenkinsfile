pipeline {
  agent any

  tools {
    jdk 'java'
    maven 'maven'
  }
  
  environment {

      sonar_url = 'http://34.172.3.155:9000'
      sonar_username = 'admin'
      sonar_password = 'admin'
      nexus_url = '34.172.3.155:8081'
      artifact_version = '4.0.0'

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
          nexusArtifactUploader artifacts: [[artifactId: 'hello-world-war', classifier: '', file: "target/hello-world-war-1.0.0.war", type: 'war']], credentialsId: 'nexus-cred', groupId: 'com.efsavage', nexusUrl: "${nexus_url}", nexusVersion: 'nexus3', protocol: 'http', repository: 'release', version: "${artifact_version}"
        }
      }
      stage ('Build Docker Image'){
        steps {
          sh '''
          cd ${WORKSPACE}
          docker build -t gcr.io/symmetric-lock-357601/halo --file=Dockerfile ${WORKSPACE}
          '''
        }
      }
      stage ('Publish Docker Image'){
        steps {
          sh '''
          docker push gcr.io/symmetric-lock-357601/halo
          '''
        }
      }
  stage ('Deploy to kubernetes'){
        steps{
          script {
            sh "kubectl config use-context gke_symmetric-lock-357601_us-central1-c_manoj"
            sh "cd ${WORKSPACE}"
            sh "kubectl delete -f '${WORKSPACE}'/k8s/deployment.yaml"
            sh "kubectl create -f '${WORKSPACE}'/k8s/deployment.yaml"
            sh "kubectl apply -f '${WORKSPACE}'/k8s/service.yaml"
          }
         }
        }
 }
}
