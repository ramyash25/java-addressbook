pipeline {
    agent any
	environment {
    		MAVEN_OPTS = '-Xms128m -Xmx512m'
    	}

    stages {
        stage('Build and Test') {
            steps {
                sh 'mvn clean test'
            }
        }

        stage('SonarCloud Analysis') {
            steps {
                withSonarQubeEnv('SonarCloud') {
                    sh '''
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:5.1.0.4751:sonar \
                        -Dsonar.projectKey=ramyash25_java-addressbook \
                        -Dsonar.organization=ramyash25 \
			-Dsonar.projectName="Java Address Book"
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality Gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }
	stage('Docker Build') {
    		steps {
        	sh '''
            	pwd
            	ls -lh
            	ls -lh target/addressbook.war
            	cat Dockerfile
            	docker build -t addressbook:${BUILD_NUMBER} .
        	'''
    		}
	}	

    }
}

