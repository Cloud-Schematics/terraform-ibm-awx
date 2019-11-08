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
![reference solution](https://github.com/Cloud-Schematics/terraform-ibm-awx/blob/master/diagrams/TerraformAWX.png)
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
When you select this terraform-ibm-awx template from the IBM Cloud catalog, you must enter the following values before you can apply the template:
  * `ssh_public_key` and `ssh_private_key:` Enter a public and private SSH key that you use to access your VPC classic infrastructure virtual server instance. For more information about adding an SSH key and uploading the key to IBM Cloud, see [Adding an SSH key](https://cloud.ibm.com/docs/infrastructure/ssh-keys?topic=ssh-keys-adding-an-ssh-key).

To apply on a standalone machine using Terraform CLI, you must enter the following values before you can apply the template:
  * `ibmcloud_api_key:` Enter the API key to access IBM Cloud VPC classic infrastructure using command
    ```export IC_API_KEY=<API-KEY-VALUE>``` on command line interface terminal.
    For more information for how to create an API key and retrieve it, see [Managing classic infrastructure API keys](https://cloud.ibm.com/docs/iam?topic=iam-classic_keys). 
   * `ssh_public_key and ssh_private_key:` Enter a public and private SSH key that you use to access your VPC classic infrastructure virtual server instance. For more information about adding an SSH key and uploading the key to IBM Cloud, see [Adding an SSH key](https://cloud.ibm.com/docs/infrastructure/ssh-keys?topic=ssh-keys-adding-an-ssh-key).


You can also choose to customize the default settings for your VPC infrastructure virtual server instance:



  Name               | Description                         | Default Value |
| -------------------| ------------------------------------|----------------
| region | Region to deploy VPC | eu-de
| subnet zone        | Zone name where AWX will be deployed| eu-de-1
| profile | Virtual Server Instance Profile | cc1-2x4
| resource group name | To organize your account resources in customizable groupings | default
| vpc_name | VPC Name | terraform-vpc-awx
| basename | Prefix used for all resource names | terraform-vpc-basename
| ssh_keyname | SSH Keyname to allow access to VSI to install AWX | ssh-key-name


## Output

The AWX web server is accessible on the deployment host. The default URL is http://floatingIP.
The floating IP (or public host) information will be available in output log of the command ```terraform apply```.

You will prompted with a login dialog. The default administrator username and the password information is available in AWX documentation.
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

https://github.com/ansible/awx/blob/devel/INSTALL.md#docker-compose

https://github.com/ansible/awx/blob/devel/INSTALL.md

https://github.com/Crazy450/terraform-aws-awx

https://cloud.ibm.com/docs/vpc-on-classic?topic=vpc-on-classic-about&locale=en

https://github.com/IBM-Cloud/vpc-tutorials

