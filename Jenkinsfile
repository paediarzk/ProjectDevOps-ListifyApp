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
                sh 'ls -la'  // Debug: list files
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t listifyapps:1.0.0 . --no-cache'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    sh '''
                        echo "Current directory:"
                        ls -la
                        echo "Running tests..."
                        docker run --rm \
                        -v "${WORKSPACE}:/app" \
                        -w /app \
                        listifyapps:1.0.0 \
                        test --stacktrace
                    '''
                }
            }
        }

        stage('Build APK') {
            steps {
                script {
                    sh '''
                        echo "Building APK..."
                        docker run --rm \
                        -v "${WORKSPACE}:/app" \
                        -v "${WORKSPACE}/.gradle:/.gradle" \
                        -w /app \
                        listifyapps:1.0.0 \
                        assembleDebug --info --stacktrace
                    '''

                    // Debug: List directory after build
                    sh '''
                        echo "Listing directory structure:"
                        find . -type f -name "*.apk"
                    '''
                }
            }
        }

        stage('Archive APK') {
            steps {
                script {
                    sh '''
                        echo "Checking for APK files..."
                        find . -name "*.apk"
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
                echo 'Pipeline failed'
                sh '''
                    echo "Listing running containers:"
                    docker ps
                    echo "Listing all containers:"
                    docker ps -a
                '''
            }
        }
    }
}