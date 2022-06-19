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
                sh 'mvn clean install -Dmaven.test.skip=true'
            }
        }
        stage ('Docker build and push'){
            steps {
                sh 'docker build -t hanzhukruslan/$JOB_NAME:$BUILD_NUMBER .'
                sh 'docker push hanzhukruslan/$JOB_NAME:$BUILD_NUMBER'
                sh 'docker rmi hanzhukruslan/$JOB_NAME:$BUILD_NUMBER'
            }
        }
        stage('Vault') {
            steps {
                withVault(configuration: [timeout: 60, vaultCredentialId: 'Vault-Jenkins-app-role', vaultUrl: 'http://65.108.210.42:8800'], vaultSecrets: [[engineVersion: 2, path: 'secret/db-connects/$JOB_NAME', secretValues: [[envVar: 'flyway_url', vaultKey: 'flyway.url'], [envVar: 'flyway_user', vaultKey: 'flyway.user'], [envVar: 'flyway_password', vaultKey: 'flyway.password']]],]) {
                    sh "echo ${env.flyway_url}"
                    sh "echo ${env.flyway_user}"
                    sh "echo ${env.flyway_password}"
                  }
                }
              }
        stage ('Flyway migrate') {
            steps {
                sh 'docker run --rm -v $WORKSPACE/flywayDB/sql/:/flyway/sql flyway/flyway -url=$flyway_url -user=$flyway_user -password=$flyway_password migrate'
            }
        }
        stage ('Deploy'){
            steps {
                sh 'ssh root@65.108.155.54 "kubectl set image -n flyway deployment/spring-flyway-outside spring-flyway-outside=hanzhukruslan/$JOB_NAME:$BUILD_NUMBER"'
            }
        }
    }
}