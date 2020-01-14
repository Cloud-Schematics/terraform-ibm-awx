# This file is used to install AWX and it's prerequisites on VSI

provider "ibm" {
  generation = "${var.generation}"
  region     = "${var.region}"
}

# Module to create Infrastructure
module vpc_pub_priv {
  source              = "infrastructure/"
  basename            = "${var.basename}"
  resource_group_name = "${var.resource_group_name}"
  basename            = "${var.vpc_basename}"
  subnet_zone         = "${var.subnet_zone}"
  ssh_key_id          = "${ibm_is_ssh_key.public_sshkey.id}"
  image               = "${var.image}"
  profile             = "${var.profile}"
}

# Resource to execute awx_install.sh script on VSI
resource "null_resource" "awxinstall" {
  connection {
    type        = "ssh"
    user        = "root"
    host        = "${module.vpc_pub_priv.floating_ip_address}"
    private_key = "${tls_private_key.vision_keypair.private_key_pem}"
  }

  provisioner "remote-exec" {
    script = "awx_install.sh"
  }
}

output "awxaccess" {
  value = "Access AWX via browser http://${module.vpc_pub_priv.floating_ip_address}"
}

#Create an SSH key which will be used for provisioning by this template, and for debug purposes
resource "ibm_is_ssh_key" "public_sshkey" {
  name       = "${var.vpc_basename}-public-key"
  public_key = "${tls_private_key.vision_keypair.public_key_openssh}"
}

#Create a ssh keypair which will be used to provision code onto the system - and also access the VM for debug if needed.
resource "tls_private_key" "vision_keypair" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}
