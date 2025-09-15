pipeline {
    agent any

    tools {
        dockerTool 'latest'
    }

    stages {
        stage("Checkout") {
            steps{
                script{
//                     git credentialsId: 'bitbucket', url: "git@bitbucket.org:ives-system/${commit.repo}.git", branch: "${ref}"
                    echo "Checkout"
                }
            }
        }

        stage("Build") {
            steps{
                script{
                    if (fileExists("Dockerfile")) {
                        echo "Dockerfile found!"
                    } else {
                        echo "NO Dockerfile!"
                    }
                }
            }
        }

        stage("Publish") {
            steps{
                script{
                    if (fileExists("Dockerfile")) {
                        echo "Dockerfile found!"
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
//             discordSend webhookURL: DISCORD_WEBHOOK_URL,
//                     successful: true,
//                     title: "Build Success",
//                     link: env.BUILD_URL,
//                     description: ":white_check_mark: $DISCORD_MESSAGE"
        }
        failure {
//             discordSend webhookURL: DISCORD_WEBHOOK_URL,
//                     successful: false,
//                     title: "Build Failed",
//                     link: env.BUILD_URL,
//                     description: ":poop: $DISCORD_MESSAGE"
        }
    }
}
