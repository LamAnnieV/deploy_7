################################### A W S #################################

provider "aws" {
  access_key = var.access_key  #enter your aws access_key
  secret_key = var.secret_key  #enter your aws secret_key
  region = var.region   #Availability Zone
  #profile = "Admin"
}

################################### I N S T A N C E # 1 #################################

resource "aws_instance" "tf_local_instance_1" {
  ami = var.ami                            #AMI ID for Ubuntu
  instance_type = var.instance_type
  subnet_id = var.instance_1_attach_existing_subnet 
  vpc_security_group_ids = var.instance_1_existing_sg #[aws_security_group.tf_local_security_group_1.id]  #new sg and exiting
  user_data = "${file(var.instance_1_installs)}"
  key_name = var.key_pair          # name of your SSH key pair
  associate_public_ip_address = true  # Enable Auto-assign public IP

  tags = {
    "Name" : var.aws_instance_1_name     #name of the instance in AWS
  }
}

################################### I N S T A N C E # 2 #################################

resource "aws_instance" "tf_local_instance_2" {
  ami = var.ami                            #AMI ID for Ubuntu
  instance_type = var.instance_type
  subnet_id = var.instance_2_attach_existing_subnet
  
  #security_groups = var.instance_1_existing_sg   #existing sg     (error)
  vpc_security_group_ids = var.instance_1_existing_sg #[aws_security_group.tf_local_security_group_2.id]   #new sg 
  user_data = "${file(var.instance_1_installs)}"
  key_name = var.key_pair          # name of your SSH key pair
  associate_public_ip_address = true  # Enable Auto-assign public IP

  tags = {
    "Name" : var.aws_instance_2_name   #name of the instance in AWS
  }
}

################################### I N S T A N C E # 3 #################################

resource "aws_instance" "tf_local_instance_3" {
  ami = var.ami                            #AMI ID for Ubuntu
  instance_type = var.instance_type
  subnet_id = var.instance_3_attach_existing_subnet
  vpc_security_group_ids = var.instance_1_existing_sg #[aws_security_group.tf_local_security_group_2.id]   #new sg 
  user_data = "${file(var.instance_1_installs)}"
  key_name = var.key_pair          # name of your SSH key pair
  associate_public_ip_address = true  # Enable Auto-assign public IP

  tags = {
    "Name" : var.aws_instance_3_name   #name of the instance in AWS
  }
}
################################### O U T P U T #################################

output "instance_1_ip" {            
  value = aws_instance.tf_local_instance_1.public_ip
}
