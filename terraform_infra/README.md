# Spring PetClinic Sample Application Deploy to AWS EC2


## What have been accomplished for this deployment:
* Building AWS Infrastructure as Code (IaC) using Terraform (more details can be found in the infra diagram)
* Containerized a Spring Boot JAVA application using Dockerfile
* Set up Jenkins server in EC2 linux 
* Pushed the container image to ECR
* Deployed the JAVA application in AWS EC2
* Configured the network to allow HTTP requests to the EC2 instance 
* Used Route 53 and Certificate Manager to set up a custom domain and provision an SSL certificate
* Configured application load balancer to forward HTTPS traffic to our EC2 instance
* Connect MySQL database to the web serve to achieve several functions

## Brief steps for the deployment
1) Using Terraform to create the infrastructure (The terraform scripts are included in ***terraform_infra*** folder)

 With everything set up, we need to change all the variables to your own before run the commands to deploy our infrastructure. The variables are listed below:

```
aws_region      = "your region"
domain_name     = "your domain name"
container_port     = "your container_port"
alb_alarm_email_address = "your alb_alarm_email_address"
common_tags     = "your common tags"
```

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

4) Install Git
<a href="https://www.atlassian.com/git/tutorials/install-git">Install Git</a>

```
sudo yum install git
git --version
git config --global user.name "Your name"
git config --global user.email "Your user.email"
```

5) Run CICD pipeline on Jenkins server
   
Once the is successfully build, you will see the following picture.

![Alt text](./images/jenkins_pipeline.png?raw=true "jenkins_pipeline")

 If the build step is failed, try to read the **Console Output** and solve the issue.

 It might take over 10 min for ec2 server to run the docker image for the first time. After that, you can click the awesome customer url: https://petclinic.sunjenny.net.

![Alt text](./images/petclinic-web.png?raw=true "petclinic-web")

The applications allows you to perform the following set of functions:

- Add Pets
- Add Owners
- Finding Owners
- Finding Veterinarians
- Exceptional handling


## AWS infrastructure diagram

![Alt text](./images/architecture_ec2.png?raw=true "architecture_ec2")

The above diagram is the AWS infrastructure where I deployed the Spring-boot Petclinic application. The procedures can be found below:

* The Jenkins pipeline will be triggered every time developer push/merge the code
* The docker image will be built and pushed to private AWS ECR
* The EC2 instance will pull the docker image and run the application, export the port 80
* The load balancer listens to the target group which directs to the port 80 from the EC2 instance
* When user type https://petclinic.sunjenny.net, the load balancer will forward HTTPS traffic to our EC2 instance
* Load balancer has monitoring functions. It will work with cloudwatch to monitor metrics, and send email notifications through AWS SNS
* The .tfstates file is stored in S3 bucket as well as Dynamodb for safety issues

## However, due to the time limit and cost, the application was only deployed in the public subnet. There are still improvements that can be made for the future production environment:

![Alt text](./images/production-ecs-2.png?raw=true "production-ecs")

* AWS ECS fargate should be employed instead of EC2 instances, as it has the scalable clusters of managed Docker containers for better web application deliver
* Autoscaling function should be applied to AWS ECS as it can monitor your applications and automatically adjusts capacity to maintain steady, predictable performance at the lowest possible cost
* The AWS ECS service should be put in the private subnet for safety reason, and they can be connected by application load balancer which is in the public subnet.
* Monitoring features including grafana, Prometheus, and elasticsearch should be used for monitoring and logging purposes
* Ansible can be used to provision the infrastructure of ECS
* Database such as MySQL, MongoDB should be configured with AWS ECS

