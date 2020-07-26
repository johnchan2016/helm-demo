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
                                echo "Yes"
                            } else {
                                echo "No"
                            }
                                                    
                            sh 'git config --global user.name "johnchan"'
                            sh 'git config --global user.email myhk2009@gmail.com'
                            sh "echo VERSION=${env.VERSION} >> ${HELM_ENVFILE}"
                            sh "echo REGION=${REGION} >> ${HELM_ENVFILE}"

                            def gitStatus = sh('git status -s')
                            echo "${gitStatus}"

                            if (gitStatus =~ /nothing to commit/){
                                sh 'git status -s'
                                sh 'git add .'
                                sh "git commit -m 'Update version no to ${env.VERSION}'"
                                sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
                            } else {
                                echo 'nothing to commit'
                            }
                        }
                    }
                }      
            }
        }
    }
}
 

// node {
//     def app

//     environment {
//       VERSION="1.1.0"
//       REGION="hk"
//     }

//     stage('Clone repository') {
//         sh 'echo "Start Clone"'
//         checkout scm
//     }

//     stage('Build & Deploy image') {
//         sh 'echo "Start Build"'
//         docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
//             app = docker.build("myhk2009/whale:${env.VERSION}")
//             app.push();
//         }
//     }

//     stage('git push') {
//         environment {
//             helm_envFilePath="env.properties"
//         }

//         dir("helm-chart") {
//             deleteDir()
//         }

//         sh 'git clone https://github.com/johnchan2016/helm-chart.git'

//         dir("helm-chart") {
//             withCredentials([usernamePassword(credentialsId: 'gitHubCredentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
//                 script {
//                     env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
//                     env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")
//                 }
                
//                 sh 'git config --global user.name "johnchan"'
//                 sh 'git config --global user.email myhk2009@gmail.com'
//                 sh "rm ${env.helm_envFilePath}"
//                 sh "echo VERSION=$VERSION >> $helm_envFilePath"
//                 sh "echo REGION=$REGION >> $helm_envFilePath"
//                 sh 'git status'
//                 sh 'git add .'
//                 sh "git commit -m 'Update version no to $VERSION'"
//                 sh 'git push https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
//             }
//         }
//     }
// }