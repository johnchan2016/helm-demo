pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
         stage('Clone repository') { 
            steps { 
                script{
                checkout scm
                }
            }
        }

        stage('Build') { 
            steps { 
                script{
								 docker -v
                }
            }
						
						//app = docker.build("underwater")
        }
				
        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
    }
}