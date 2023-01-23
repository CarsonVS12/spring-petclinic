pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }
    
    environment {
        AWS_REGION = "ap-southeast-2"
        AWS_Creds_name = "sunjenny_AWS"
        ImgName = "spring-petclinic"
        ImgTag = "latest"
        S3Bucket_UAT_Bucket = "spring-petclinic-sunjenny"
        WorkDir = "./"
        ArtifactDir = "./target"
        ECRRegistry_URL = "368399608041.dkr.ecr.ap-southeast-2.amazonaws.com"
        HTTP_Port = "8080"
    }

    stages {
        stage('Build image') {
            steps{
                dir(WorkDir) {
                    echo 'Building image with docker...'
                    sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} . --platform linux/amd64"
                }
            } 
        }

        stage('Log in to AWS ECR') {
            steps {
                dir(WorkDir) {
                    withAWS(credentials: "${AWS_Creds_name}", region: "${AWS_REGION}") {
                    echo 'Logging in to AWS ECR...'
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECRRegistry_URL}"
                    }
                }
            }
        }

        stage('Pushing image to ECR') {
            steps{  
                dir(WorkDir) {
                    echo 'Pushing image to ECR'
                    sh 'docker tag ${ImgName}:${ImgTag} ${ECRRegistry_URL}/${ImgName}:${ImgTag}'
                    sh 'docker push ${ECRRegistry_URL}/${ImgName}:${ImgTag}'
                }
            }
        }

        stage('Deploy image to AWS EC2') {
            steps{
                dir(WorkDir) {
                    withAWS(credentials: "${AWS_Creds_name}", region: "${AWS_DEFAULT_REGION}") {
                        echo 'Deploying image to AWS EC2...'
                        sh 'docker pull ${ECRRegistry_URL}/${ImgName}:${ImgTag}'
                        sh 'docker run -d --rm -p ${HTTP_Port}:8080 --name ${ImgName} ${ImgName}:${ImgTag}'
                    }
                }  
            }
        }
    }
    post {
        always{
            cleanWs()
            // emailext body: '$DEFAULT_CONTENT', subject: '$DEFAULT_SUBJECT', to: '$DEFAULT_RECIPIENTS'
        }
    }

    
    // post {
    //     always {
    //         echo "Sending Emails......"
    //         emailext body: '$DEFAULT_CONTENT', subject: '$DEFAULT_SUBJECT', to: '$DEFAULT_RECIPIENTS'
    //         cleanWs()
    //     }
    //     success {
    //         bitbucketStatusNotify(buildState: 'SUCCESSFUL')
    //     }
    //     failure {
    //         bitbucketStatusNotify(buildState: 'FAILED')
    //     }
    // }
}