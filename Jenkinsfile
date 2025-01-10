pipeline {
    agent any

     // Define environment variables for Docker image name and tag.
    environment {
        DOCKER_IMAGE = 'listifyapps'
        DOCKER_TAG = '1.0.0'
    }

    // Stage 1: Check out the source code.
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                bat 'dir'
            }
        }

        // Stage 2: Build the Docker image.
        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t listifyapps:1.0.0 . --no-cache'
                }
            }
        }

        // Stage 3: Run tests inside the Docker container.
        stage('Run Tests') {
            steps {
                script {
                    bat '''
                        echo "Running tests..."
                        docker run --rm ^
                        -v "%WORKSPACE%:/app" ^
                        -w /app ^
                        listifyapps:1.0.0 ^
                        test
                    '''
                }
            }
        }

        // Stage 4: Build the Android APK.
        stage('Build APK') {
            steps {
                script {
                    bat '''
                        echo "Building APK..."
                        docker run --rm ^
                        -v "%WORKSPACE%:/app" ^
                        -v "%WORKSPACE%\\.gradle:/.gradle" ^
                        -w /app ^
                        listifyapps:1.0.0
                    '''

                    bat 'dir /s /b *.apk'
                }
            }
        }

        // Stage 5: Archive the APK file.
        stage('Archive APK') {
            steps {
                script {
                    archiveArtifacts(
                        artifacts: '**/app/build/outputs/apk/debug/*.apk',
                        fingerprint: true,
                        allowEmptyArchive: false
                    )
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            script {
                echo 'Pipeline failed'
                bat 'docker ps -a'
            }
        }
    }
}