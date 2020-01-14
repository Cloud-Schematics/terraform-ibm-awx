variable "profile" {
  description = "The profile of compute CPU and memory resources that you want your VPC virtual servers to have. To list available profiles, run `ibmcloud is instance-profiles` for target generation."
  default     = "bx2-4x16"
}

variable "resource_group_name" {
  description = "Enter the name of the IBM Cloud resource group where you want to provision your database instance. To list available resource groups, run `ibmcloud resource groups`."
}

variable "vpc_basename" {
  description = "Represents a name of the VPC that awx will be deployed into. Resources associated with awx will be prepended with this name."
  default     = "terraform-vpc-awx"
}

variable "subnet_zone" {
  description = "The zone to create this instance of awx. To get a list of all regions, run `ibmcloud is zones us-south` for target generation."
  default     = "us-south-1"
}

variable "region" {
  description = "The region to create your VPC in, such as `us-south`. To get a list of all regions, run `ibmcloud is regions` for target generation."
  default     = "us-south"
}

variable "generation" {
  description = "Target the generation of compute resources. Default is '2'. You must set the value to '1' to access generation 1 resources."
  default     = 2
}

variable "image" {
  description = "The name of the image that represents the operating system that you want to install on your VPC virtual server. To list available images, run `ibmcloud is images` for target generation. The default image is for an `ibm-centos-7-6-minimal-amd64-1` OS."
  default     = "ibm-centos-7-6-minimal-amd64-1"
}
