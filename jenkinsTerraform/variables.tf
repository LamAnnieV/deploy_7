################## D E C L A R E - V A R I A B L E ####################

################################### A W S #################################

variable "access_key" {}
variable "secret_key" {}
variable "region" {}


################################### I N S T A N C E # 1 #################################

variable "ami" {}
variable "instance_type" {}
variable "instance_1_attach_existing_subnet" {}      #existing subnet
variable "instance_1_existing_sg" {}      #existing sg
variable "instance_1_installs" {}
variable "key_pair" {}
variable "aws_instance_1_name" {}

################################### I N S T A N C E # 2 #################################

variable "instance_2_attach_existing_subnet" {}      #existing subnet
variable "instance_2_installs" {}
variable "aws_instance_2_name" {}

################################### I N S T A N C E # 3 #################################

variable "instance_3_attach_existing_subnet" {}      #existing subnet
variable "instance_3_installs" {}
variable "aws_instance_3_name" {}
