# This file is used to install AWX and it's prerequisites on VSI

provider "ibm" {
  generation   = 2
  region = "${var.region}"
}


# Module to create Infrastructure
module vpc_pub_priv {
  source              = "infrastructure/"
  basename            = "${var.basename}"
  resource_group_name = "${var.resource_group_name}"
  vpc_name = "${var.vpc_name}"
  subnet_zone = "${var.subnet_zone}"
  ssh_keyname = "${var.ssh_keyname}"
  ssh_keyname = "${ibm_is_ssh_key.public_sshkey.id}"
}

# Resource to execute awx_install.sh script on VSI
resource "null_resource" "awxinstall" {
  connection {
    type = "ssh"
    user = "root"
    host = "${module.vpc_pub_priv.floating_ip_address}"
    private_key = "${file(local.ssh_privatekey_file)}"
  }
  provisioner "remote-exec" {
    script = "awx_install.sh"
  }
  depends_on = ["null_resource.create_ssh_keys"]
}

output "awxaccess" {
 value = "Access AWX via browser http://${module.vpc_pub_priv.floating_ip_address}"
}

output "sshcommand" {
 value = "ssh command => ssh root@${module.vpc_pub_priv.floating_ip_address}"
}

resource "ibm_is_ssh_key" "public_sshkey" {
  name = "${var.ssh_keyname}"
  public_key = "${file(local.ssh_publickey_file)}"
  depends_on = ["null_resource.create_ssh_keys"]
}

locals {
  ssh_publickey_file = "sshkey_id_rsa.pub"
}

locals {
  ssh_privatekey_file = "sshkey_id_rsa"
}

resource "null_resource" "create_ssh_keys" {
  provisioner "local-exec" {
    command = "ssh-keygen -q -t rsa -N '' -f sshkey_id_rsa <<< y;chmod 600 sshkey_id_rsa*"
    interpreter = ["/bin/bash", "-c"]
  }
}

output "resource_cloud" {
   value = {
            "resource_controller_url" = "http://${module.vpc_pub_priv.floating_ip_address}"
             "resource_name" = "AWX"
  }
}

