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
                bat 'dir'
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