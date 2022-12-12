pipeline {
    agent any
		
		stages {
        stage('Cloning Git') {
            steps {
                sh 'echo "Start Clone"'
                checkout scm
            }
        }

        stage('Building image') {
            steps{
                script {
                    echo "VERSION: ${env.VERSION}";
                    //dockerImage = docker.build registry + ":${env.VERSION}"
										app = docker.build("octopus-underwater-app")
                }
            }
        }
		}
}