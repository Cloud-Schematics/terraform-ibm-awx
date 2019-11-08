
variable "profile" {
  	description = "Virtual Server Instance Profile"
  	default = "cc1-2x4"
}

variable "resource_group_name" {
	description = "To organize your account resources in customizable groupings"
        default = "default"
}

variable "vpc_name" {
	description = "VPC Name"
        default = "terraform-vpc-awx"
}

variable "basename" {
  	description = "Prefix used for all resource names"
  	default = "terraform-vpc-basename"
}

variable "subnet_zone" {
	description = "Prefix used for all resource names"
 	default = "eu-de-1"
}

variable "region" {
	description = "Region to deploy VPC"
 	default = "eu-de"
}

variable "ssh_keyname" {
	description = "SSH Keyname to allow access to VSI to install AWX"
  	default = "ssh-key-name"
}

variable "ssh_public_key" {
	description = "SSH Public key to allow automation to access to VSI to install AWX"
}

variable "ssh_private_key" {
	description = "SSH Private key to allow automation to access to VSI to install AWX"
}
