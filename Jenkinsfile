pipeline {
    agent any

    environment {
        IMAGE_NAME = "${env.GIT_URL}".toLowerCase().split('/').last().replaceAll('.git', '')
        IMAGE_REPO = "${DOCKER_REGISTRY_URL}/${IMAGE_NAME}"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    echo "Dynamically determined IMAGE_NAME: ${IMAGE_NAME}"

                    def dockerTagArgs = " --tag ${IMAGE_REPO}:${env.BRANCH_NAME.replaceAll('/', '-')}"

                    if (env.TAG_NAME) {
                        echo "Building for Git tag: ${env.TAG_NAME}"
                        dockerTagArgs += " --tag ${IMAGE_REPO}:${env.TAG_NAME}"
                    }

                    echo "Executing docker build with tags:${dockerTagArgs}"
                    sh "docker build ${dockerTagArgs} ."
                }
            }
        }

        stage('Publish') {
            when {
              expression { env.DOCKER_REGISTRY_URL }
            }

            steps {
                script {
                    echo "Publishing Docker image ${IMAGE_REPO} with all its tags"

                    sh "docker login ${env.DOCKER_REGISTRY_URL} -u '${env.DOCKER_REGISTRY_USER}' -p '${env.DOCKER_REGISTRY_PASS}'"
                    sh "docker push ${IMAGE_REPO}:${env.BRANCH_NAME.replaceAll('/', '-')}"

                    if (env.TAG_NAME) {
                        sh "docker push ${IMAGE_REPO}:${env.TAG_NAME}"
                    }
                }
            }
        }

        stage('Binaries') {
            when {
              expression { env.BINARIES_DIR }
            }

            steps {
                script {
                    if (readFile('Dockerfile').toLowerCase().contains('FROM scratch AS binaries'.toLowerCase())) {
                        def OUTPUT_DIR = "${env.BINARIES_DIR}/${IMAGE_NAME}/${env.BRANCH_NAME.replaceAll('/', '-')}"
                        echo "Publishing branch binaries to ${OUTPUT_DIR}"
                        sh "docker build --output=${OUTPUT_DIR} --target=binaries ."

                        if (env.TAG_NAME) {
                            OUTPUT_DIR = "${env.BINARIES_DIR}/${IMAGE_NAME}/${env.TAG_NAME}"

                            echo "Publishing tag binaries to ${OUTPUT_DIR}"
                            sh "docker build --output=${OUTPUT_DIR} --target=binaries ."
                        }
                    }
                }
            }
        }
    }

    post{
        always {
            echo "Running post actions"
        }
        success{
            echo "Success"
        }
        failure {
            echo "Failure"
        }
    }
}
