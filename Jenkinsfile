pipeline {
    agent any
    stages {
        stage('Test') {
					script{
						checkout scm
					}
        }
				
				stage('Build') { 
					steps { 
						script{
									app = docker.build("octopus-underwater-app")
								}
						}
				}
    }
}