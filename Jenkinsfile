pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }
    
    environment {
        AWS_DEFAULT_REGION = "ap-southeast-2"
        AWS_Creds_name = "Spring-petclinic"
        S3Bucket_UAT_Bucket = "uat.linkdevapp.com"
        WorkDir = "./"
        ArtifactDir = "./target"
        Distribution_ID = "E1MV3CMCEU2IWH"
        ENV_key = ".env"
        // S3Bucket_State_Bucket = "linkdevapp-state-bucket"
        // S3Bucket_Envfile_Path = "env-files/uat/frontend/.env"
    }

    stages {
        stage('Install dependencies') {
            steps{
                echo 'Installing...'
                withAWS(region:'ap-southeast-2',credentials:'LinkDev_AWS'){
                    dir(WorkDir) {
                        s3Download(file: "$ENV_key", bucket: "$S3Bucket_State_Bucket", path: "$S3Bucket_Envfile_Path")
                        sh 'npm i'
                    }
                }
            }
        }
        stage('Build') {
            steps{
                echo 'Building...'
                dir(WorkDir) {
                    sh 'mvn spring-boot:run'
                }
            }
        } 
        stage('Upload the artifact to AWS S3 bucket') {
            steps {
                withAWS(region:'ap-southeast-2',credentials:'LinkDev_AWS') {
                    echo "Uploading artifact to AWS S3 bucket..."
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:"$ArtifactDir", bucket:"$S3Bucket_UAT_Bucket")
                }
            }
        }
        stage('Invalidate CloudFront cache') {
            steps {
                withAWS(region:'ap-southeast-2',credentials:'LinkDev_AWS') {
                    echo "Invalidating CloudFront cache..."
                    cfInvalidate(distribution:"$Distribution_ID", paths:['/*'], waitForCompletion: true)
                }
            }
        }
    }
    
    post {
        always {
            echo "Sending Emails......"
            emailext body: '$DEFAULT_CONTENT', subject: '$DEFAULT_SUBJECT', to: '$DEFAULT_RECIPIENTS'
            cleanWs()
        }
        success {
            bitbucketStatusNotify(buildState: 'SUCCESSFUL')
        }
        failure {
            bitbucketStatusNotify(buildState: 'FAILED')
        }
    }
}