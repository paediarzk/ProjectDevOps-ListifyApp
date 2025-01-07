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
                bat 'dir'  // Windows equivalent of ls -la
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t listifyapps:1.0.0 . --no-cache'
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
                        -v "%WORKSPACE%:/app" ^
                        -w /app ^
                        listifyapps:1.0.0 ^
                        test --stacktrace
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
                        -v "%WORKSPACE%:/app" ^
                        -v "%WORKSPACE%\\.gradle:/.gradle" ^
                        -w /app ^
                        listifyapps:1.0.0 ^
                        assembleDebug --info --stacktrace
                    '''

                    // Debug: List directory after build
                    bat 'dir /s /b *.apk'
                }
            }
        }

        stage('Archive APK') {
            steps {
                script {
                    bat 'dir /s /b *.apk'
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
                echo 'Pipeline failed'
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