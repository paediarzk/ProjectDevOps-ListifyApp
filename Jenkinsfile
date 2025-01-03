pipeline {
    agent any
    
    stages {
        //check or pull the code from git repository
        stage('Checkout') {
            steps {
                git branch: 'feature-crud', url: 'https://github.com/paediarzk/ProjectDevOps-ListifyApp.git'
            }
        }
        // to builds a docker image
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t paediarzk/listifyapp .'
            }
        }
        
        // to runs a container from the image built in the previous stage.
        stage('Run Docker Container') {
            steps {
                bat 'docker run -d paediarzk/listifyapp'
            }
        }
    }
    
  // This block defines actions that occur after the pipeline completes, either successfully or with failure. 
    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
    }
}
