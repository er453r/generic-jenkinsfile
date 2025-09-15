pipeline {
    agent any

    tools {
        dockerTool 'latest'
    }

    environment {
        IMAGE_NAME = "${env.JOB_BASE_NAME ?: env.JOB_NAME}".toLowerCase().split('/').last()
        IMAGE_REPO = "${DOCKER_REGISTRY_URL}/${IMAGE_NAME}"
    }

    stages {
        stages {
            stage('Build') {
                steps {
                    script {
                        sh 'env | sort'

                        echo "Dynamically determined IMAGE_NAME: ${IMAGE_NAME}"

                        def dockerTagArgs = ""
                        dockerTagArgs += " --tag ${IMAGE_REPO}:${BUILD_NUMBER}"

                        if (env.BRANCH_NAME) {
                            def safeBranchName = env.BRANCH_NAME.replaceAll('/', '-')
                            echo "Building for branch: ${env.BRANCH_NAME}. Using sanitized tag: ${safeBranchName}"
                            dockerTagArgs += " --tag ${IMAGE_REPO}:${safeBranchName}"
                        }

                        if (env.TAG_NAME) {
                            echo "Building for Git tag: ${env.TAG_NAME}"
                            dockerTagArgs += " --tag ${IMAGE_REPO}:${env.TAG_NAME}"
                            dockerTagArgs += " --tag ${IMAGE_REPO}:latest"
                        }

                        echo "Executing docker build with tags:${dockerTagArgs}"
                        sh "docker build ${dockerTagArgs} ."
                    }
                }
            }

            stage('Publish') {
                steps {
                    script {
                        echo "Publishing Docker image ${IMAGE_REPO} with all its tags"

                        sh "docker login ${env.DOCKER_REGISTRY_URL} -u ${env.DOCKER_REGISTRY_USER} -p ${env.DOCKER_REGISTRY_PASS}"
                        sh "docker push --all-tags ${IMAGE_REPO}"
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
