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
                    env.GIT_COMMIT_MESSAGE = sh(returnStdout: true, script: 'git log -1 --pretty=%B').trim()
                    env.GIT_COMMITTER_NAME = sh(returnStdout: true, script: 'git log -1 --pretty=%cn').trim()
                    env.GIT_COMMITTER_EMAIL = sh(returnStdout: true, script: 'git log -1 --pretty=%ce').trim()

                    env.DISCORD_MESSAGE = "`${IMAGE_NAME}:${env.BRANCH_NAME.replaceAll('/', '-')} (${GIT_COMMIT.substring(0,8)})` build by `${GIT_COMMITTER_NAME}`\n\n> ${GIT_COMMIT_MESSAGE}"

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

            script {
                if(env.DISCORD_WEBHOOK_URL){
                    discordSend webhookURL: env.DISCORD_WEBHOOK_URL,
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
                if(env.DISCORD_WEBHOOK_URL){
                    discordSend webhookURL: env.DISCORD_WEBHOOK_URL,
                            successful: false,
                            title: "Build Failed",
                            link: env.BUILD_URL,
                            description: ":poop: $DISCORD_MESSAGE"
                }
            }
        }
    }
}
