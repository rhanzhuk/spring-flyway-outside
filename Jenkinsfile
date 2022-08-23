pipeline{
    agent any
    environment {
        VAULT_ADDR = 'http://65.108.210.185:8211'
    }
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
        stage("Vault and Flyway") {
            steps {
                withCredentials([string(credentialsId: 'VAULT_TOKEN', variable: 'VAULT_TOKEN')]) {
                    script {
                        try {
                    	    def roleId = sh(script: "curl --header 'X-Vault-Token: $VAULT_TOKEN' $VAULT_ADDR/v1/auth/approle/role/jenkins-role/role-id | jq -r .data.role_id", returnStdout: true).trim()
                    		def secretId = sh(script: "curl --header 'X-Vault-Token: $VAULT_TOKEN' --request POST $VAULT_ADDR/v1/auth/approle/role/jenkins-role/secret-id | jq -r .data.secret_id", returnStdout: true).trim()
                    		def apiToken = sh(script: """ curl -v --request POST --data '{ \"role_id\": \"$roleId\", \"secret_id\": \"$secretId\" }' http://65.108.210.185:8211/v1/auth/approle/login | jq -r .auth.client_token""", returnStdout: true).trim()
                    		def dbUrl = sh(script: "curl  --header 'X-Vault-Token: $apiToken' ${VAULT_ADDR}/v1/secret/data/db-connects/spring-flyway-outside | jq -r .data.data.flyway_url", returnStdout: true).trim()
                    		def dbUser = sh(script: "curl  --header 'X-Vault-Token: $apiToken' ${VAULT_ADDR}/v1/secret/data/db-connects/spring-flyway-outside | jq -r .data.data.flyway_user", returnStdout: true).trim()
                    		def dbPass = sh(script: "curl  --header 'X-Vault-Token: $apiToken' ${VAULT_ADDR}/v1/secret/data/db-connects/spring-flyway-outside | jq -r .data.data.flyway_password", returnStdout: true).trim()
                    		sh "pwd && ls -la $WORKSPACE && ls -la $WORKSPACE/flywayDB/sql/ && docker run --rm -v $WORKSPACE/flywayDB/sql/:/flyway/sql flyway/flyway -url=$dbUrl -user=$dbUser -password=$dbPass migrate"
                    	} catch (errorVar) {
                    	    println "$errorVar"
                    	}
                    }
                }
            }
        }
        stage('Vault and Flyway') {
            steps {
                withVault(configuration: [timeout: 60, vaultCredentialId: 'Vault-Jenkins-app-role', vaultUrl: 'http://65.108.210.185:8211'], vaultSecrets: [[engineVersion: 2, path: 'secret/db-connects/$JOB_NAME', secretValues: [[envVar: 'flyway_url', vaultKey: 'flyway.url'], [envVar: 'flyway_user', vaultKey: 'flyway.user'], [envVar: 'flyway_password', vaultKey: 'flyway.password']]],]) {
                    sh "echo ${env.flyway_url}"
                    sh "echo ${env.flyway_user}"
                    sh "echo ${env.flyway_password}"
                    sh 'docker run --rm -v $WORKSPACE/flywayDB/sql/:/flyway/sql flyway/flyway -url=$flyway_url -user=$flyway_user -password=$flyway_password migrate'
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