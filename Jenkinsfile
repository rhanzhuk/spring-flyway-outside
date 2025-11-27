pipeline {
    agent any

    stages {
        stage("Maven build") {
            steps {
                script {
                    sh "docker run -v $env.WORKSPACE:/opt/maven -w /opt/maven  maven mvn clean install -Dmaven.test.skip=true"
                }
            }
        }

        stage("Build docker image") {
            steps {
                script {
                    sh "docker build -t java-sec-demo:${BUILD_NUMBER} ."
                    sh "docker ps"
                    sh "docker rmi java-sec-demo:${BUILD_NUMBER}"
                }
            }
        }

        stage("Print this vars") {
            steps {
                script {
                    sh "echo Test"
                }
            }
        }

        stage("Build maven") {
            steps {
                script {
                    sh "echo Test"
                }
            }
        }

        stage("Docker build") {
            steps {
                script {
                    sh 'echo Test'
                }
            }
        }

        stage("Deploy image") {
            steps {
                script {
                    sh "echo Test"
                }
            }
        }
    }
}