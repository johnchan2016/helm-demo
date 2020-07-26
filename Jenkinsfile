/* pipeline {
  environment {
    registry = "myhk2009/whale"
    registryCredential = 'dockerHubCredentials'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/gustavoapolinario/microservices-node-example-todo-frontend.git'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
 */

node {
    def app
    def code_envFilePath
    def helm_envFilePath
    def VERSION
    def REGION

    environment {
      code_envFilePath="./config/env.txt"
      helm_envFilePath="env.txt"
      VERSION="1.1.0"
      REGION="hk"
    }

    stage('Clone repository') {
        sh 'echo "Start Clone"'
        checkout scm
    }

    stage('Build & Deploy image') {
        sh 'echo "Start Build"'
        docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
            app = docker.build("myhk2009/whale")
            app.push(VERSION);
        }
    }

    stage('git push') {
        dir("helm-chart") {
            deleteDir()
        }

        sh 'git clone https://github.com/johnchan2016/helm-chart.git'

        dir("helm-chart") {
            withCredentials([usernamePassword(credentialsId: 'gitHubCredentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                script {
                    env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                    env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")
                }
                
                sh 'git config --global user.name "johnchan"'
                sh 'git config --global user.email myhk2009@gmail.com'
                // sh "echo ${VERSION}"
                // sh "rm ${helm_envFilePath}"
                // sh "echo VERSION=${VERSION} >> ${helm_envFilePath}"
                // sh "echo REGION=${REGION} >> ${helm_envFilePath}"
                sh 'git status'
                sh 'git add .'
                sh "git commit -m 'Update version no to $VERSION'"
                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
            }
        }
    }

/*     stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhubCredentials') {
            app.push("1.0.0")
            app.push("latest")
        }
    } */
}