# Spring PetClinic Sample Application Deploy to AWS EC2


## What have been accomplished for this deployment:
* Building AWS Infrastructure as Code (IaC) using Terraform (more details can be found in the infra diagram)
* Containerized a Spring Boot JAVA application using Dockerfile
* Pushed the container image to ECR
* Deployed the JAVA application in AWS EC2
* Configured the network to allow HTTP requests to the EC2 instance 
* Used Route 53 and Certificate Manager to set up a custom domain and provision an SSL certificate
* Configured application load balancer to forward HTTPS traffic to our EC2 instance
* Connect MySQL database to the web serve to achieve several functions

## Brief steps for the deployment
1) Using Terraform to create the infrastructure (The terraform scripts are included in ***terraform_infra*** folder)

```
git clone https://github.com/sunjuice2022/spring-petclinic.git
cd terraform_infra
terraform init
terraform plan
terraform apply --auto-approve=true
```

 You will be able to see the ip address of the ec2 server and use key.pem to login the server

```
chmod 400 key.pem
ssh -i key.pem ec2@<ip address>
```

2) Install Jenkins on ec2 instance
<a href="https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#jenkins-on-aws">Jenkins on AWS</a>

 Once the Jenkins is installed and configured, go to **Manage jenkins**, **Manage Plugins**, install plugins including **AWS, aws pipeline, docker, CloudBees AWS, ec2, ansicolor, email extensions** etc

 Then go to **Manage jenkins**, **Manage Credentials** to manage AWS credentials


3) Install Docker 
<a href="https://docs.docker.com/desktop/install/linux-install/">Install on Linux</a>

```
sudo docker login
sudo systemctl start docker
```

 Don't forget to add group membership for the default ec2-user so you can run all docker commands without using the sudo command, and add “jenkins” user to the “docker” group

```
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
```

4) Run CICD pipeline on Jenkins server
   
Once the is successfully build, you will see the following picture.

![Alt text](./images/jenkins_pipeline.png?raw=true "jenkins_pipeline")

If the build step is failed, try to read the **Console Output** and solve the issue.


1) It might take over 10 min for ec2 server to run the docker image for the first time. After that, you can click the awesome customer url: https://petclinic.sunjenny.net.

![Alt text](./images/petclinic-web.png?raw=true "petclinic-web")

The applications allows you to perform the following set of functions:

- Add Pets
- Add Owners
- Finding Owners
- Finding Veterinarians
- Exceptional handling


