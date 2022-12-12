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
								sh 'docker -v'
            }
        }
				
        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
    }
}