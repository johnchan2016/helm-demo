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
            app = docker.build("getintodevops/hellonode")
        }
				
        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
    }
}