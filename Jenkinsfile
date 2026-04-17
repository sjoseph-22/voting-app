pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'sjoseph22'
        DOCKER_HUB_CREDS = 'docker-hub-cred'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Images') {
            steps {
                script {
                    // Define list of services/directories
                    def services = ['vote', 'result', 'worker']

                    // Loop through each service
                    for (service in services) {
                        stage("Service: ${service}") {
                            echo "Processing ${service}..."

                            // Use the directory name as the image name
                            def imageName = "${DOCKER_HUB_USER}/voting-app-${service}"
                            
                            // 1. Build the image
                            // This looks for the Dockerfile inside the specific folder
                            def app = docker.build("${imageName}:${env.BUILD_NUMBER}", "./${service}")

                            // 2. Push to Docker Hub
                            docker.withRegistry('', DOCKER_HUB_CREDS) {
                                app.push("${env.BUILD_NUMBER}")
                                app.push("latest")
                            }
                            
                            // 3. Optional: Cleanup local image to save space
                            sh "docker rmi ${imageName}:${env.BUILD_NUMBER} ${imageName}:latest"
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "All three images (Vote, Result, Worker) pushed successfully!"
        }
    }
}