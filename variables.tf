
variable "profile" {
  	description = "Virtual Server Instance Profile (default: Generation 2)"
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
	description = "Prefix used for all resource names (default: Generation 2)"
 	default = "us-south-1"
}

variable "region" {
	description = "Region to deploy VPC (default: Generation 2)"
 	default = "us-south"
}

variable "ssh_keyname" {
	description = "SSH Keyname to allow access to VSI to install AWX"
  	default = "ssh-key-name"
}

variable "gen" {
	description = "Generation (default: Generation 2)"
  	default = 2
}

variable "image" {
	description = "VSI Image (default: Generation 2)"
  	default = "ibm-centos-7-6-minimal-amd64-1"
}
