pipeline {
    agent any
    
    stages {
        // Checkout code from Git repository
        stage('Checkout') {
            steps {
                git branch: 'feature-crud', url: 'https://github.com/paediarzk/ProjectDevOps-ListifyApp.git'
            }
        }

        // Build Docker Image
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t listifyapps:1.0.0 . --no-cache'
            }
        }
        
        // Run Docker Container
        stage('Run Docker Container') {
            steps {
                bat 'docker run -d listifyapps:1.0.0'
            }
        }
        
        // Run Tests
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
                        listifyapps:1.0.0 bash -c "./gradlew test --stacktrace"
                    '''
                }
            }
        }
        
        // Build APK
        stage('Build APK') {
            steps {
                script {
                    bat '''
                        echo "Building APK..."
                        docker run --rm ^
                        -v "%CD%":/app ^
                        -v "%CD%/.gradle:/root/.gradle" ^
                        -w /app ^
                        listifyapps:1.0.0 bash -c "./gradlew assembleDebug --info --stacktrace"
                    '''
                    
                    // Debug: List directory after build
                    bat '''
                        echo "Listing directory structure:"
                        dir /s
                    '''
                }
            }
        }
        
        // Archive APK
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
    
    // Post actions after pipeline completion
    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
    }
}
