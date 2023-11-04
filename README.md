# Deploy Banking Application in Elastic Container Service 

November 4, 2023

By:  Annie V Lam - Kura Labs

# Purpose

Deploy Banking Application in ECS Container 

Previously, Jenkins agent infrastructure was used to apply Terraform .tf files that would create the main infrastructure that would deploy the banking application in four public subnets.  In addition, an RDS was configured to synchronize the databases across all four subnets.  In this deployment, Elastic Container Services with a docker image was used to deploy the banking application.  

## Step #1 Diagram the VPC Infrastructure and the CI/CD Pipeline

![Deployment Diagram](Images/Deployment_Pipeline.png)

## Step #2 GitHub/Git

**Setup GitHub Repository for Jenkins Integration:**

GitHub serves as the repository from which Jenkins retrieves files to build, test, and build the infrastructure for the banking application and deploy the banking application.  

In order for the EC2 instance, where Jenkins is installed, to access the repository, you need to generate a token from GitHub and then provide it to the EC2 instance.

[Generate GitHub Token](https://github.com/LamAnnieV/GitHub/blob/main/Generate_GitHub_Token.md)

Update files in the GitHub repository using [git](Images/git.md)

## Step #3 Dockerfile

A Docker image is a template of an application with all the dependencies it needs to run. A docker file has all the components to build the Docker image.

For this deployment, we need to create a [dockerfile](dockerfile) to build the image of the banking application.  Please see the [GIT - docker file](Images/git.md) section to see how to test the dockerfile to see if it can build the image and if the image is deployable.

## Step #4 Jenkins

**Jenkins**

Jenkins automates the Build, Test, and Deploy the Banking Application.  To use Jenkins in a new EC2, all the proper installs to use Jenkins and to read the programming language that the application is written in need to be installed. In this case, they are Jenkins, Java, and Jenkins' additional plugin "Pipeline Keep Running Step", which is manually installed through the GUI interface.

**Jenkins Agent Infrastructure**

Use Terraform to spin up the [Jenkins Agent Infrastructure](jenkinsTerraform/main.tf) to include the installs needed for the [Jenkins instance](jenkinsTerraform/installs1.sh), the install needed for the [Jenkins Docker agent instance](jenkinsTerraform/installs2.sh), and the install needed for the [Jenkins Terraform agent instance](jenkinsTerraform/installs3.sh),.

**Setup Jenkins and Jenkins nodes**

[Create](https://github.com/LamAnnieV/Create_EC2_Instance/blob/main/Create_Key_Pair.md) a Key Pair

Configure Jenkins

Instructions on how to configure the [Jenkin node](https://github.com/LamAnnieV/Jenkins/blob/main/jenkins_node.md)

Instructions on how to configure [AWS access and secret keys](https://github.com/LamAnnieV/Jenkins/blob/main/AWS_Access_Keys), that the Jenkin node will need to execute Terraform scripts

Instructions on how to configure [Docker credentials](https://github.com/LamAnnieV/Jenkins/blob/main/docker_credentials.md), to push the docker image to Docker Hub

Instructions on how to install the [Pipleline Keep Running Step](https://github.com/LamAnnieV/Jenkins/blob/main/Install_Pipeline_Keep_Running_Step.md)

Instructions on how to install the [Docker Pipeline](https://github.com/LamAnnieV/Jenkins/blob/main/Install_Docker_Pipeline_Plugin.md)


## Step #5 Configure Amazon's Relational Database Service (RDS) 

RDS is used to manage the MySQL database in all four instances in this case.  It can automate backups and sync the data across regions, availability zones, and instances.  It also ensures security and reliability

How to [configure RDS database](https://github.com/LamAnnieV/AWS_RDS_Database/blob/main/Create_AWS_RDS_DB).

Update the section in yellow, green, and blue of the Database endpoint in the following files:  app.py, database.py, and load_data.py

![DATABASE_URL](Images/Database_URL.png)

![DATABASE_URL](Images/Endpoint.png)

![Images](Images/DB_name.png)


## Step #6 Use Jenkins Terraform Agent to execute the Terraform scripts to create the Banking Application Infrastructure and Deploy the application on ECS with Application Load Balancer

**Banking Application Infrastructure**

Create the following [banking application infrastructure](intTerraform/vpc.tf):  

```
1 VPC
2 Availability Zones (AZ) us-eas-1a and us-east-1b
2 Public Subnets one in each AZ
2 Private Subnets one in each AZ
2 Route Table
1 Internet Gateway connected to one route table
1 Nate Gateway with Elastic IP and connected to the other route table
1 Security Group with port 80
1 Security Group with port 8000
```

**Elastic Container Service (ECS)**

Create the following [Elastic Container Service](intTerraform/main.tf):  

```
```

**Application Load Balancer (ALB)**

The purpose of an Application Load Balancer (ALB) is to evenly distribute incoming web traffic to multiple servers or instances to ensure that the application remains available, responsive, and efficient. It directs traffic to different servers to prevent overload on any single server. If one server is down, it can redirect traffic to the servers that are still up and running.  This helps improve the performance, availability, and reliability of web applications, making sure users can access them without interruption, even if some servers have issues.

Create the following [Application Load Balancer](intTerraform/ALB.tf):  

```
```




To automate the construction of the banking application infrastructure, the instance with the Jenkins agent and Terraform will execute the Terraform scripts. The [main.tf](Images/main.tf) and [variables.tf](Imaages/variables.tf) files, define the resources to be created and declare variables. Additionally, Terraform enables the execution of a [deploy.sh](initTerraform/deploy.sh) that  includes installing dependencies and deploying the banking application. 

The portion of the deploy.sh script that would deploy the application:

![image](Images/Deploy_script.png)

Jenkins Build:  In Jenkins create a build "deploy_6" to run the file Jenkinsfilev for the Banking application from GitHub Repository [https://github.com/LamAnnieV/deploy_6.git](https://github.com/LamAnnieV/deploy_6.git) and run the build.  This build consists of:  The "Build", the "Test", the "Clean", (Terraform) "Init", (Terraform) "Plan", and (Terraform) "Apply" stages.  The "Apply" stage also includes deploying the application.   

**Results:**

Success Build for all Stages

![Image](Images/Jenkins.png)

The application was launched from all four instances:

![Images](Images/Launch_1.png)
![Images](Images/Launch_2.png)
![Images](Images/Launch_3.png)
![Images](Images/Launch_4.png)

## Step #6 Configure Application Load Balancer to distribute the workload

The purpose of an Application Load Balancer (ALB) is to evenly distribute incoming web traffic to multiple servers or instances to ensure that the application remains available, responsive, and efficient. It directs traffic to different servers to prevent overload on any single server. If one server is down, it can redirect traffic to the servers that are still up and running.  This helps improve the performance, availability, and reliability of web applications, making sure users can access them without interruption, even if some servers have issues.

How to configure [Application Load Balancer](https://github.com/LamAnnieV/AWS_Services/blob/main/Application_Load_Balancer.md)

![Images](Images/Load_Balancer_East.png)

![Images](Images/Load_Balancer_West.png)

## Step #7 Configure Amazon Route 53 DNS Service

Amazon Route 53 is a scalable and highly available Domain Name System (DNS) web service provided by Amazon Web Services (AWS). It allows you to register domain names and manage their settings.  It efficiently routes incoming DNS requests to the appropriate resources.  In this case, it will be EC2 instances.  This helps distribute traffic and improve the availability and performance of the applications.  Route 53 can monitor the health of your resources and automatically route traffic away from failed resources to healthy ones. This is crucial for ensuring high availability and fault tolerance.  Route 53 can be used to create sophisticated traffic routing policies based on geographic location, latency, weighted distribution, and more. This enables you to optimize the user experience and control how traffic is distributed.

How to configure Amazon DNS Service [Route 53](https://github.com/LamAnnieV/AWS_Services/blob/main/route_53.md)

![Images](Images/dns_name.png)

![Images](Images/dns_result.png)

## Issue(s)

Most of the challenges revolved around Terraform, not having enough AWS resources and user error

1.  When updating the database endpoint in the files, had to try two different options to figure out which one was the actual database name DB instance identifier or initial database name.  It was the initial database name.  
2. When configuring the RDS, port 3306 was initially not configured, which caused an unsuccessful test stage 
3.  How to create a two-region infrastructure with one main.tf.  It was simply giving an alias to the second provider, and inserting the provider = aws.<alias> for each block related to that provider.  The other blocks will default to the main provider. 
4.  Terraform was giving an error that there was not enough CPU or internet gateways available.  Had to terminate unused resources, before re-running Terraform
6.  When configuring the application load balancer, selecting the correct VPC was missed.  Had to recreate the load balancer 
  
## Area(s) for Optimization:

-  Enhance automation of the AWS Cloud Infrastructure by implementing Terraform modules.
-  Using Auto Scaling Groups in conjunction with the ALB for dynamic scaling based on traffic load.
-  Use Dockerfiles to deploy the application


Note:  ChatGPT was used to enhance the quality and clarity of this documentation
  
