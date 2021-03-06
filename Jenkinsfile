pipeline {
  environment {
    registry = "myhk2009/whale"
    registryCredential = 'dockerHubCredentials'
    dockerImage = ""

    REGION="hk"
    CODE_ENVFILE="env.groovy"
    HELM_ENVFILE="env.properties"
  }

    agent any

    stages {
        stage('Cloning Git') {
            steps {
                sh 'echo "Start Clone"'
                checkout scm

                load "${CODE_ENVFILE}"
                sh('printenv | sort')    
            }
        }

        stage('Building image') {
            steps{
                script {
                    echo "VERSION: ${env.VERSION}";
                    dockerImage = docker.build registry + ":${env.VERSION}"
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

        stage('helm-chart') {
            steps{
                dir("helm-chart") {
                    deleteDir()
                }

                sh 'git clone https://github.com/johnchan2016/helm-chart.git'

                dir("helm-chart") {
                    withCredentials([usernamePassword(credentialsId: 'gitHubCredentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        script {
                            env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                            env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")

                            if (fileExists("${HELM_ENVFILE}")) {
                                sh "rm -rf  ${HELM_ENVFILE}"
                            }
                                                    
                            sh 'git config --global user.name "johnchan"'
                            sh 'git config --global user.email myhk2009@gmail.com'
                            sh "echo VERSION=${env.VERSION} >> ${HELM_ENVFILE}"
                            sh "echo REGION=${REGION} >> ${HELM_ENVFILE}"

                            def gitStatus = sh(script: 'git status', returnStdout: true)
                            echo "gitStatus: ${gitStatus}"
                            if (gitStatus =~ /(.*)nothing to commit(.*)/){
                                echo 'nothing to commit'
                            } else {
                                sh 'git add .'
                                sh "git commit -m 'Update version no to ${env.VERSION}'"
                                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
                            }
                        }
                    }
                }      
            }
        }
    }
}