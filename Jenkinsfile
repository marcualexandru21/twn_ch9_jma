#!/usr/bin.env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
    remote: 'https://github.com/marcualexandru21/jenkins-shared-library.git',
    credentialsId: 'github-credentials'])

pipeline {   
    agent any
    tools {
        maven 'maven-3.9.9'
    }
    environment {
        def IMAGE_NAME = 'mbradu/twn-ch9-jma:'
    }
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."

                }
            }
        }

        stage("increment version") {
            steps {
                script {
                   sh 'mvn build-helper:parse-version versions:set \
                   -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                   versions:commit'

                }
            }
        }

        stage("build") {
            steps {
                script {
                    buildJar()
                }
            }
        }

        stage("build the docker image") {
            steps {
                script{
                    def version = sh(script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout", returnStdout: true).trim()
                     env.FULL_IMAGE_NAME = "${IMAGE_NAME}${version}-${BUILD_NUMBER}"

                    buildImage(env.FULL_IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.FULL_IMAGE_NAME)
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    def shellCmd = "bash ./server-cmds.sh ${env.FULL_IMAGE_NAME}"
                    def userAndServer = "ec2-user@18.184.225.119"
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${userAndServer}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${userAndServer}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${userAndServer} ${shellCmd}"
                    }
                }
            }
        }

        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials-ex-ch8-with-token', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'git config user.email "marcualexandru21@gmail.com"'
                        sh 'git config user.name "marcualexandru21"'

                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/marcualexandru21/twn_ch9_jma.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:starting-code'
                    }
                }
            }
        }
    }
} 
