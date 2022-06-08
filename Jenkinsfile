pipeline{
    agent any
    stages{
        stage ('Build jar') {
            agent {
                docker {
                    image 'maven'
                    args '-v /var/lib/jenkins/.m2:/root/.m2'
                    reuseNode true
                }
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage ('Docker build and push'){
            steps {
                sh 'docker build -t hanzhukruslan/$JOB_NAME:$BUILD_NUMBER .'
                sh 'docker push hanzhukruslan/$JOB_NAME:$BUILD_NUMBER'
                sh 'docker rmi hanzhukruslan/$JOB_NAME:$BUILD_NUMBER'
            }
        }
        stage ('Flyway migrate') {
            agent {
                docker {
                    image 'flyway/flyway'
                    args '-v /flywayDB/sql/:/flyway/sql -v /flywayDB/conf/:/flyway/conf'
                    reuseNode true
                }
            }
            steps {
                sh 'migrate'
            }
        }
        stage ('Deploy'){
            steps {
                sh 'ssh root@65.108.155.54 "kubectl set image -n flyway deployment/spring-flyway-outside spring-flyway-outside=hanzhukruslan/$JOB_NAME:$BUILD_NUMBER"'
            }
        }
    }
}