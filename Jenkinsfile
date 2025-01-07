pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'listifyapps'
        DOCKER_TAG = '1.0.0'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out the source code...'
                checkout scm
                bat 'dir' // Debug: List files in workspace
            }
        }

        stage('Fix Line Endings') {
            steps {
                script {
                    echo 'Fixing line endings for gradlew...'
                    // Replace Windows-style line endings (CRLF) with Unix-style (LF)
                    bat '''
                        powershell -Command "(Get-Content gradlew) -replace '\\r', '' | Set-Content gradlew"
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat '''
                        docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% . --no-cache
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo 'Running tests inside Docker container...'
                    bat '''
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
                    echo 'Building APK file...'
                    bat '''
                        docker run --rm ^
                        -v "%CD%":/app ^
                        -v "%CD%/.gradle:/root/.gradle" ^
                        -w /app ^
                        %DOCKER_IMAGE%:%DOCKER_TAG% ^
                        ./gradlew assembleDebug --info --stacktrace
                    '''

                    // Debug: List directory after build
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
                    echo 'Archiving APK files...'
                    bat '''
                        echo "Searching for APK files..."
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
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Gathering logs for debugging...'
            bat '''
                echo "Listing running containers:"
                docker ps
                echo "Listing all containers:"
                docker ps -a
            '''
        }
    }
}
