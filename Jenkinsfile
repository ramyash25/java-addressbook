pipeline {
    agent any
	environment {
    		MAVEN_OPTS = '-Xms128m -Xmx512m'
		AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '417873488781.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'java-addressbook'
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
 	stage('Trivy Security Scan') {
    		steps {
        	sh 'trivy image --severity HIGH,CRITICAL --exit-code 1 addressbook:${BUILD_NUMBER}'
    		}
	}
	stage('Push to AWS ECR') {
            steps {
            sh '''
            /usr/local/bin/aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}

            docker tag addressbook:${BUILD_NUMBER} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}

            docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${BUILD_NUMBER}
            '''
            }
	}

    }
}

