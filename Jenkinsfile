pipeline {
    agent any

    environment {
        IMAGE_NAME = "${env.GIT_URL}".toLowerCase().split('/').last().replaceAll('.git', '')
        IMAGE_REPO = "${DOCKER_REGISTRY_URL}/${IMAGE_NAME}"
        DISCORD_MESSAGE = "`${IMAGE_NAME}:${env.BRANCH_NAME.replaceAll('/', '-')} (${GIT_COMMIT})` build by `${GIT_COMMITTER_NAME}`"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh 'printenv'

                    echo "Dynamically determined IMAGE_NAME: ${IMAGE_NAME}"

                    def dockerTagArgs = " --tag ${IMAGE_REPO}:${env.BRANCH_NAME.replaceAll('/', '-')}"

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

            when {
              expression { env.DOCKER_REGISTRY_URL }
            }

            script {
                if(env.DOCKER_REGISTRY_URL){
                    discordSend webhookURL: DISCORD_WEBHOOK_URL,
                            successful: true,
                            title: "Build Success",
                            link: env.BUILD_URL,
                            description: ":white_check_mark: $DISCORD_MESSAGE"
                }
            }
        }
        failure {
            echo "Failure"

            script {
                if(env.DOCKER_REGISTRY_URL){
                    discordSend webhookURL: DISCORD_WEBHOOK_URL,
                            successful: false,
                            title: "Build Failed",
                            link: env.BUILD_URL,
                            description: ":poop: $DISCORD_MESSAGE"
                }
            }
        }
    }
}
