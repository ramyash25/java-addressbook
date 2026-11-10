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
                // This securely injects the secret token you saved in Step 1
                SONAR_TOKEN = credentials('SONARCLOUD_TOKEN')
            }
        steps {
        // Runs the official scanner container to analyze and push code details to the cloud
        sh """
            docker run --rm \
                -e SONAR_HOST_URL="https://sonarcloud.io" \
                -e SONAR_TOKEN="${SONAR_TOKEN}" \
                -v "\$(pwd):/usr/src" \
                sonarsource/sonar-scanner-cli \
                -Dsonar.projectKey=ramyash25_java-addressbook \
                -Dsonar.organization=ramyash25
        """
    }
}

        stage('package') {
            steps { 
                sh 'mvn package'
            }
        }
    }
}
