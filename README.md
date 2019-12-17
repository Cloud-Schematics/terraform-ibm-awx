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
To apply the terraform-ibm-awx template in IBM Cloud with IBM Cloud Schematics, you must select the template from the [IBM Cloud catalog](https://cloud.ibm.com/catalog#software), enter the configuration for your VPC classic virtual server instance, and install the template. When you install the template, IBM Cloud Schematics creates a workspace and starts provisioning your resources by using Terraform. You can review logs and your resources from the IBM Cloud Schematics console. For more information, see the [IBM Cloud Schematics documentation](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics).


##  Configuring your deployment values
To apply on a standalone machine using Terraform CLI, you must enter the following values before you can perform `terraform plan` and `terraform apply`:
  * `ibmcloud_api_key:` Enter the API key to access IBM Cloud VPC classic infrastructure using command
    ```export IC_API_KEY=<API-KEY-VALUE>``` on command line interface terminal.
    For more information for how to create an API key and retrieve it, see [Managing classic infrastructure API keys](https://cloud.ibm.com/docs/iam?topic=iam-classic_keys). 

You can also choose to customize the default settings for your VPC infrastructure virtual server instance:


  Name               | Description                         | Default Value |
| -------------------| ------------------------------------|----------------
| region | Region to deploy VPC | eu-de
| subnet zone        | Zone name where AWX will be deployed| eu-de-1
| profile | Virtual Server Instance Profile | cc1-2x4
| resource group name | To organize your account resources in customizable groupings | default
| vpc_name | VPC Name | terraform-vpc-awx
| basename | Prefix used for all resource names | terraform-vpc-basename

## Output


  Name               | Description                          
| -------------------| ------------------------------------
| AWX web server address |  The default URL is http://floatingIP 

### Where to find the floatingIP
On a Standalone machine using Terraform Command Line Interface (CLI):
The floating IP (or public host) information will be available in "Outputs:" section of the ```terraform apply``` output log.

Using IBM Cloud Schematics:
The floating IP (or public host) information will be available in "View Log" (under "Outputs:") of "Plan applied" activity.

### Accessing AWX Server
Upon clicking http://floatingIP you will be prompted with a login dialog. The default administrator username and the password information is available in AWX documentation.
https://github.com/ansible/awx/blob/devel/INSTALL.md

## AWX Console
---
![reference solution](https://github.ibm.com/epradeepk/Terraform-AWX-Generation2/blob/master/diagrams/AWX_Login_Page.png)
---
 
## AWX Dashboard
---
![reference solution](https://github.ibm.com/epradeepk/Terraform-AWX-Generation2/blob/master/diagrams/AWX_Dashboard.png)

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
