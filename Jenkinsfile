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
 
stage('deploy') {
  steps {
    script {
      docker.withRegistry(
        'https://<405767789238>.dkr.ecr.<public.ecr.aws/s3t7r5c3/dcoker.demo>.amazonaws.com',
        'ecr:<us-east-1>:<my.aws.credentials>' {
          def myImage = docker.build('<dcoker.demo>')
          myImage.push('<latest>')
        } } } }
 }
}
