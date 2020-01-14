# ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) Terraform AWX on IBM Cloud VPC

## Overview

Use this template to provision AWX on Virtual Private Cloud (VPC) Infrastructure in IBM Cloud by using Terraform or IBM Cloud Schematics. The AWX is automatically configured along with security groups so that it can be readily accessible after installation using your virtual server instance's floating IP address.

Refer to `Deployment` section below for more details about the deployment information.

## Infrastructure

* Deployment platform: Docker Compose
* One Virtual Server Instance (VSI)
* Subnet
* Public Gateway
* Security Group and Security Group Rules for Ingress and Egress
* Resource Group
* Floating IP

## Costs

When you apply template, the infrastructure resources that you create incur charges as follows. To clean up the resources, you can [delete your Schematics workspace or your instance](https://cloud.ibm.com/docs/schematics?topic=schematics-manage-lifecycle#destroy-resources). Removing the workspace or the instance cannot be undone. Make sure that you back up any data that you must keep before you start the deletion process.

* **VPC**: VPC charges are incurred for the infrastructure resources within the VPC, as well as network traffic for internet data transfer. For more information, see [Pricing for VPC](https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc).
* **VPC virtual servers**: The price for your virtual server instances depends on the flavor of the instances, how many you provision, and how long the instances are run. For more information, see [Pricing for Virtual Servers for VPC](https://cloud.ibm.com/docs/infrastructure/vpc-on-classic?topic=vpc-on-classic-pricing-for-vpc#pricing-for-virtual-servers-for-vpc).

## Prerequisites

#### 1. On a Standalone machine using Terraform Command Line Interface (CLI)

* Download and install [Terraform for your system](https://learn.hashicorp.com/terraform/getting-started/install.html)
* Download the IBM Cloud provider [plugin for Terraform](https://github.com/IBM-Cloud/terraform-provider-ibm/releases)
* Unzip the release archive to extract the plugin binary (terraform-provider-ibm_vX.Y.Z).
* Move the binary into the Terraform plugins directory for the platform.
    * Linux/Unix/OS X: ~/.terraform.d/plugins
* IBM Cloud account (to provision resources on IBM Cloud VPC)

The Terraform scripts will take care of installing below list of additional prerequisites on the provisioned VSI (where the AWX will be installed).

* Ansible - a recent version
* Docker - a recent version
* docker-compose Python module
* Docker Compose
* Git - a recent version 

#### 2. Using IBM Cloud Schematics
You should have a Paid account to perform this deployment


## Architecture Diagram

The following figure illustrates the deployment architecture for the 'AWX on IBM Cloud VPC' (the text in `orange` color is used to represent the resource names that are used in the code).

---
![reference solution](https://github.com/Cloud-Schematics/terraform-ibm-awx/blob/master/diagrams/TerraformAWXDiagram1.png)
---


## Deployment

The Terraform performs the following deployment Steps

- Provision VPC Infrastructure with one VSI 
- Deploy AWX on the provisioned VSI 

The deployment of AWX on IBM Cloud VPC can be done in two ways

#### 1. On a Standlone machine using Terraform CLI

Install prerequisites and clone this GitHub Repo. Run Terraform commands to provision the Infrastructure on IBM Cloud VPC. The Terraform will deploy AWX on provisioned Infrastructure.

```
terraform init
terraform plan
terraform apply
```

The deployed resources can be seen using below command

```terraform show```

#### 2. Using IBM Cloud Schematics
To apply the terraform-ibm-awx template in IBM Cloud with IBM Cloud Schematics, you must create workspace from the [IBM Cloud schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics) and start managing resources lifecycle. You can review logs and your resources from the IBM Cloud Schematics console. For more information, see the [IBM Cloud Schematics documentation](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics).


##  Configuring your deployment values
To apply on a standalone machine using Terraform CLI, you must enter the following values before you can perform `terraform plan` and `terraform apply`:
  * `ibmcloud_api_key:` Enter the API key to access IBM Cloud VPC classic infrastructure using command
    ```export IC_API_KEY=<API-KEY-VALUE>``` on command line interface terminal.
    For more information for how to create an API key and retrieve it, see [Managing classic infrastructure API keys](https://cloud.ibm.com/docs/iam?topic=iam-classic_keys). 

### Required values
Fill in the following values, based on the steps that you completed before you began.

|Variable Name|Description|
|-------------|-----------|
|`resource_group_name`|Enter the name of the IBM Cloud resource group where you want to provision your database instance. To list available resource groups, run `ibmcloud resource groups`.|


You can also choose to customize the default settings for your VPC infrastructure virtual server instance:


  Name               | Description                         | Default Value - Generation 2 | Default Value - Generation 1
| -------------------| ------------------------------------|------------------------------|------------------------------
| region | The region to create your VPC in, such as `us-south`. To get a list of all regions, run `ibmcloud is regions` for target generation. | us-south | eu-de
| subnet zone | The zone to create this instance of awx. To get a list of all regions, run `ibmcloud is zones us-south` for target generation.| us-south-1 | eu-de-1
| profile | The profile of compute CPU and memory resources that you want your VPC virtual servers to have. To list available profiles, run `ibmcloud is instance-profiles` for target generation. | bx2-4x16 | cc1-2x4
| image | The name of the image that represents the operating system that you want to install on your VPC virtual server. To list available images, run `ibmcloud is images` for target generation. The default image is for an `ibm-centos-7-6-minimal-amd64-1` OS.|ibm-centos-7-6-minimal-amd64-1 | centos-7.x-amd64
| vpc_basename | Represents a name of the VPC that awx will be deployed into. Resources associated with awx will be prepended with this name. | terraform-vpc-basename | terraform-vpc-basename
| generation | Target the generation of compute resources. Default is '2'. You must set the value to '1' to access generation 1 resources. | 2 | 1


## Output

  Name               | Description                          
| -------------------| ------------------------------------
| AWX web server address |  The default URL is http://floatingIP 

### Where to find the floatingIP
On a Standalone machine using Terraform Command Line Interface (CLI):
The floating IP (or public host) information will be available in "Outputs:" section of the ```terraform apply``` output log.

Using IBM Cloud Schematics: 
The AWX web link is available in two places
- under workspace "Resources" in AWX section and 
- at "View Log" (under "Outputs:") of "Plan applied" activity.

### Accessing AWX Server
Upon clicking http://floatingIP you will be prompted with a login dialog. The default administrator username and the password information is available in AWX documentation.
https://github.com/ansible/awx/blob/devel/INSTALL.md

## AWX Console
---
![reference solution](https://github.com/Cloud-Schematics/terraform-ibm-awx/blob/master/diagrams/AWX_Login_Page.png)
---
 
## AWX Dashboard
---
![reference solution](https://github.com/Cloud-Schematics/terraform-ibm-awx/blob/master/diagrams/AWX_Dashboard.png)

---

## Destroying the deployed Infrastructure and AWX

#### 1. On a Standalone machine using Terraform CLI
Using below command the deployed Infrastructure and AWX can be destroyed

```terraform destroy```

#### 2. Using IBM Cloud Schematics
Select option Actions in the created workspace and choose Destroy Resources/Destroy workspace.


## References

https://www.ibm.com/cloud/garage/tutorials/public-cloud-infrastructure

https://github.com/ibm-cloud-architecture/refarch-vsi-on-vpc

https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-strategies-for-resilient-applications

https://github.com/ansible/awx/blob/devel/INSTALL.md

https://github.com/Crazy450/terraform-aws-awx

https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-about&locale=en

https://github.com/IBM-Cloud/vpc-tutorials
