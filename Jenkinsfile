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
        env.IMAGE_NAME = 'mbradu/twn-ch9-jma:1.1'
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
                    def dockerCmd = 'docker run -p 8080:8080 -d mbradu/twn-ch9-jma:1.0'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.184.225.119 ${dockerCmd}"
                    }
                }
            }
        }               
    }
} 
