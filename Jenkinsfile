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
                bat 'docker build -t listifyapps:1.0.0 . --no-cache'
            }
        }
        
        // to runs a container from the image built in the previous stage.
        stage('Run Docker Container') {
            steps {
                bat 'docker run -d listifyapps:1.0.0'
            }
        }
    }

     stage('Run Tests') {
            steps {
                script {
                    bat '''
                        echo "Current directory:"
                        dir
                        echo "Running tests..."
                        docker run --rm ^
                        -v "%CD%":/app ^
                        -w /app ^
                        listifyapps:1.0.0 ^
                        ./gradlew test --stacktrace
                    '''
                }
            }
        }
        
        stage('Build APK') {
            steps {
                script {
                    bat '''
                        echo "Building APK..."
                        docker run --rm ^
                        -v "%CD%":/app ^
                        -v "%CD%/.gradle:/root/.gradle" ^
                        -w /app ^
                         listifyapps:1.0.0 ^
                        ./gradlew assembleDebug --info --stacktrace
                    '''
                    
                    // Debug: List direktori setelah build
                    bat '''
                        echo "Listing directory structure:"
                        dir /s
                    '''
                }
            }
        }
        
        stage('Archive APK') {
            steps {
                script {
                    bat '''
                        echo "Checking for APK files..."
                        dir /s *.apk
                    '''
                    archiveArtifacts(
                        artifacts: '**/*.apk',
                        fingerprint: true,
                        allowEmptyArchive: false
                    )
                }
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
