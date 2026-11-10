pipeline {
    agent any
    stages {
        stage('Compile') {
            steps { 
                sh 'mvn compile'
            }
        }
        stage('test') {
            steps { 
                sh 'mvn test'
            }
        }
       stage('SonarCloud Code Analysis') {
        environment {
        SONAR_TOKEN = credentials('SONARCLOUD_TOKEN')
        }
        steps {
        // 1. Run the scan as you did before
            sh """
                docker run --rm \
                    -e SONAR_HOST_URL="https://sonarcloud.io" \
                    -e SONAR_TOKEN="${SONAR_TOKEN}" \
                    -v "\$(pwd):/usr/src" \
                    sonarsource/sonar-scanner-cli \
                    -Dsonar.projectKey=ramyash25_java-addressbook \
                    -Dsonar.organization=ramyash25
        """
        
        // 2. Wait for SonarCloud to return the Quality Gate result
        timeout(time: 5, unit: 'MINUTES') {
            script {
                def qg = waitForQualityGate()
                if (qg.status != 'OK') {
                    error "Pipeline aborted due to Quality Gate failure: ${qg.status}"
                }
            }
        }
    }
}

        stage('package') {
            steps { 
                sh 'mvn package'
            }
        }
    }
}
