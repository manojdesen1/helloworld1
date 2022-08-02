pipeline {
  agent any

  tools {
    jdk 'java'
    maven 'maven'
  }
  
  environment {

      sonar_url = 'http://18.224.215.207:9000'
      sonar_username = 'admin'
      sonar_password = 'admin'
      nexus_url = '18.224.215.207:8081'
      artifact_version = '6.0.0'
      imagename = '473476762388.dkr.ecr.us-east-2.amazonaws.com/finall:latest'
      registryCredential = 'my.aws.credentials'
      dockerImage = '' 

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
   stage('Building image') {
    steps{
      script {
         dockerImage = docker.build imagename
       }
     }
  }
    stage('Deploy Image') {
      steps{
      script {
        docker.withRegistry('https://473476762388.dkr.ecr.us-east-2.amazonaws.com/finall:my.aws.credentials')  {
         dockerImage.push("$BUILD_NUMBER")
         dockerImage.push('latest')
        }
       }
      }
   }
      stage('Remove Unused docker image') {
        steps{
         
         sh 'sudo docker rmi $(sudo docker images -aq) --force'
         }
       }
        
  
  
  
  
  
}
}
