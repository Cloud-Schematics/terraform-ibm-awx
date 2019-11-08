# This file is used to install AWX and it's prerequisites on VSI

provider "ibm" {
  generation       = 1
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
  ssh_public_key = "${var.ssh_public_key}"
}

# Resource to execute awx_install.sh script on VSI
resource "null_resource" "awxinstall" {
  connection {
    type = "ssh"
    user = "root"
    host = "${module.vpc_pub_priv.floating_ip_address}"
    private_key = "${var.ssh_private_key}"
  }
  provisioner "remote-exec" {
    script = "awx_install.sh"
  }
}

output "awxaccess" {
 value = "Access AWX via browser http://${module.vpc_pub_priv.floating_ip_address}"
}

output "sshcommand" {
 value = "ssh command => ssh root@${module.vpc_pub_priv.floating_ip_address}"
}
