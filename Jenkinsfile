pipeline {
    agent any
    
    options {
        ansiColor('xterm')
    }
    
    environment {
        AWS_REGION = "ap-southeast-2"
        AWS_Creds_name = "sunjenny_AWS"
        IMAGE_REPO_NAME = "spring-petclinic"
        IMAGE_TAG = "latest"
        S3Bucket_UAT_Bucket = "spring-petclinic-sunjenny"
        WorkDir = "./"
        ArtifactDir = "./target"
        // Distribution_ID = "E1MV3CMCEU2IWH"
        // ENV_key = ".env"
        // S3Bucket_State_Bucket = "linkdevapp-state-bucket"
        // S3Bucket_Envfile_Path = "env-files/uat/frontend/.env"
    }

    stages {
        stage('Build') {
            steps{
                dir(WorkDir) {
                    echo 'Building...'
                    // sh "docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} ."
                    sh "./mvnw spring-boot:run"
                }
            } 
        }
        stage('Upload the artifact to AWS S3 bucket') {
            steps {
                withAWS(region:'$AWS_REGION',credentials:'$AWS_Creds_name') {
                    echo "Uploading artifact to AWS S3 bucket..."
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:"$ArtifactDir", bucket:"$S3Bucket_UAT_Bucket")
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
        // stage('Invalidate CloudFront cache') {
        //     steps {
        //         withAWS(region:'ap-southeast-2',credentials:'LinkDev_AWS') {
        //             echo "Invalidating CloudFront cache..."
        //             cfInvalidate(distribution:"$Distribution_ID", paths:['/*'], waitForCompletion: true)
        //         }
        //     }
        // }
    
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