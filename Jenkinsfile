pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'listifyapps'
        DOCKER_TAG = '1.0.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                bat 'dir' // Debug: List files
            }
        }

        stage('Fix Line Endings') {
            steps {
                script {
                    // Convert line endings from CRLF to LF for gradlew
                    bat '''
                        echo "Fixing line endings for gradlew..."
                        powershell -Command "(Get-Content gradlew) -replace '\\r', '' | Set-Content gradlew"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat '''
                        echo "Building Docker image..."
                        docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% . --no-cache
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    bat '''
                        echo "Running tests..."
                        docker run --rm ^
                        -v "%CD%":/app ^
                        -w /app ^
                        %DOCKER_IMAGE%:%DOCKER_TAG% ^
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
                        %DOCKER_IMAGE%:%DOCKER_TAG% ^
                        ./gradlew assembleDebug --info --stacktrace
                    '''

                    // Debug: List directory structure
                    bat '''
                        echo "Listing directory structure..."
                        dir /s
                    '''
                }
            }
        }

        stage('Archive APK') {
            steps {
                script {
                    bat '''
                        echo "Archiving APK files..."
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

    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
        failure {
            script {
                echo 'Pipeline failed. Checking running containers...'
                bat '''
                    echo "Listing running containers:"
                    docker ps
                    echo "Listing all containers:"
                    docker ps -a
                '''
            }
        }
    }
}
