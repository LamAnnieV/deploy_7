################################### A W S #################################

access_key = ""
secret_key = ""
region = "us-east-1"


################################### I N S T A N C E # 1 #################################

ami = "ami-08c40ec9ead489470"
instance_type = "t2.micro"

                           
instance_1_attach_existing_subnet = "subnet-02b138f5e8b442a5f"  #cannot use.id here
instance_1_existing_sg = ["sg-021654b8cb3fa35c1"] #for existing security group
instance_1_installs = "installs1.sh"
key_pair = "JenkinsKeyPair"
aws_instance_1_name = "D7_jenkins"

################################### I N S T A N C E # 2 #################################

instance_2_attach_existing_subnet = "subnet-06cc1f730679a1994"  #cannot use.id here
instance_2_installs = "installs2.sh"
aws_instance_2_name = "D7_docker"

################################### I N S T A N C E # 3 #################################

instance_3_attach_existing_subnet = "subnet-06cc1f730679a1994"  #cannot use.id here
instance_3_installs = "installs3.sh"
aws_instance_3_name = "D7_terraform"
