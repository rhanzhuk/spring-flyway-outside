pipeline {
    agent any

    stages {

        stage('Gitleaks check sensative info in repo') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/repo zricethezav/gitleaks:latest detect \
                            --source=/repo \
                            --report-format=json \
                            --report-path=/repo/gitleaks-report.json || true
                    '''
                }
            }
            post {
                always { archiveArtifacts artifacts: 'gitleaks-report.json', fingerprint: true,  allowEmptyArchive: true }
            }
        }


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
                    sh "docker save java-sec-demo:${BUILD_NUMBER} -o java-sec-demo-${BUILD_NUMBER}.tar"
                    //sh "docker rmi java-sec-demo:${BUILD_NUMBER}"
                }
            }
        }

        stage('Generate SBOM with (Syft)') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/work anchore/syft:latest /work/java-sec-demo-${BUILD_NUMBER}.tar -o json > sbom.json
                        docker run --rm -v $(pwd):/work anchore/syft:latest /work/java-sec-demo-${BUILD_NUMBER}.tar -o table > sbom.txt
                        echo "======================= Выводим список библиотек в имедже ==========================="
                        cat sbom.txt
                    '''
                }
            }
            post {
                always { archiveArtifacts artifacts: 'sbom.txt', fingerprint: true }
            }
        }

        stage('Vuln scan (Grype)') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/work anchore/grype:latest \
                            sbom:/work/sbom.json \
                            -o json > grype.json || true
                        # Grype возвращает non-zero при найденных vuln; мы ловим результат ниже   
                        jq -r '.matches | length as $n | "grype matches: \\($n)"' grype.json || true
                        rm sbom.json
                        echo "======================= Выводим список уязвимостей библиотек ==========================="
                        cat grype.json
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'grype.json', fingerprint: true
                }
            }
        }

        stage('Vuln scan (Trivy)') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/work aquasec/trivy:latest image --input /work/java-sec-demo-${BUILD_NUMBER}.tar --format table > trivy.txt
                        echo "======================= Выводим таблицу уязвимостей trivy ==========================="
                        cat trivy.txt
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'trivy.txt', fingerprint: true
                    //archiveArtifacts artifacts: 'trivy.txt', allowEmptyArchive: true, fingerprint: true, onlyIfSuccessful: true
                }
            }
        }    

        stage('Image lint (Dockle)') {
            steps {
                script {
                    sh '''
                        docker run --rm -v $(pwd):/work goodwithtech/dockle:latest \
                            --input /work/java-sec-demo-${BUILD_NUMBER}.tar --format table > dockle.txt || true
                        echo "======================= Выводим не соблюдения бест практис сборки имеджа==========================="
                        cat dockle.txt
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'dockle.txt', fingerprint: true
                }
            }
        }

        stage('Kube score') {
            steps {
                script {
                    sh '''
                        docker run -v $(pwd):/project zegl/kube-score:latest score spring-flyway-outside-deployment.yml > kube-score.txt || true
                        echo "======================= Выводим не соблюдения бест практис манифестов==========================="
                        cat kube-score.txt
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'kube-score.txt', fingerprint: true
                }
            }
        }
    }
}