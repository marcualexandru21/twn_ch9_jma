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
        def IMAGE_NAME = 'mbradu/twn-ch9-jma:1.1'
    }
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."

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
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml ec2-user@18.184.225.119:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.184.225.119 ${dockerComposeCmd}"
                    }
                }
            }
        }               
    }
} 
