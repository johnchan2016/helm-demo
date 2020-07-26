node {
    def app

    environment {
      code_envFilePath="./config/env.txt";
      helm_envFilePath="env.txt";
      VERSION=1.0.0;
      REGION=hk;
    }

    stage('Clone repository') {
        sh 'echo "Start Clone"'
        checkout scm
    }

    stage('Build image') {
        sh 'echo "Start Build"'
        app = docker.build('myhk2009/whale')
    }

    stage('Test image') {
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('git push') {
        dir("helm-chart") {
            withCredentials([usernamePassword(credentialsId: 'gitHubCredentials', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                script {
                    env.encodedUser=URLEncoder.encode(GIT_USERNAME, "UTF-8")
                    env.encodedPass=URLEncoder.encode(GIT_PASSWORD, "UTF-8")
                }
                
                sh 'ls'
                sh 'git config --global user.name "johnchan"'
                sh 'git config --global user.email myhk2009@gmail.com'
                sh 'rm ${helm_envFilePath}'
                sh 'echo VERSION=${VERSION} >> ${helm_envFilePath}'
                sh 'echo REGION=${REGION} >> ${helm_envFilePath}'
                sh 'git status'
                sh 'git add .'
                sh "git commit -m 'Update version no to ${VERSION}'"
                sh 'git pull https://${encodedUser}:${encodedPass}@github.com/johnchan2016/helm-chart.git'
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