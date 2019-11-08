# This file is used for VPC Infrastructure creation that includes
# one VSI, Public Gate Way, Subnet, Security Group, Security Group Rules, Resource Group and Floating IP

resource "ibm_is_public_gateway" "awxpgw" {
  count = "1"
  vpc   = "${ibm_is_vpc.awxvpc.id}"
  name  = "${var.basename}-${var.subnet_zone}-pubgw"
  zone  = "${var.subnet_zone}"
}

resource "ibm_is_subnet" "awxsubnet" {
  name                     = "${var.basename}-subnet"
  vpc                      = "${ibm_is_vpc.awxvpc.id}"
  zone                     = "${var.subnet_zone}"
  public_gateway           = "${join("", ibm_is_public_gateway.awxpgw.*.id)}"
  total_ipv4_address_count = 256
}


data "ibm_resource_group" "group" {
  name = "${var.resource_group_name}"
}

resource "ibm_is_vpc" "awxvpc" {
  name = "${var.vpc_name}"
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_ssh_key" "sshkey" {
    name = "${var.ssh_keyname}"
    public_key = "${var.ssh_public_key}"
}


resource ibm_is_security_group "awxsg" {
  name = "${var.basename}-awxsg"
  vpc  = "${ibm_is_vpc.awxvpc.id}"
}


data ibm_is_image "image1" {
  #name = "ubuntu-18.04-amd64"
  name = "centos-7.x-amd64"
}

resource ibm_is_instance "awxvsi" {
  name           = "${var.basename}-awxvsi"
  vpc            = "${ibm_is_vpc.awxvpc.id}"
  zone           = "${var.subnet_zone}"
  keys           = ["${ibm_is_ssh_key.sshkey.id}"]
  image          = "${data.ibm_is_image.image1.id}"
  profile        = "cc1-2x4"
  resource_group = "${data.ibm_resource_group.group.id}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.awxsubnet.id}"
    security_groups = ["${ibm_is_security_group.awxsg.id}"]
  }
}

resource ibm_is_floating_ip "awxfip" {
  name   = "${var.basename}-awxfip"
  target = "${ibm_is_instance.awxvsi.primary_network_interface.0.id}"
}

output sshcommand {
  value = "ssh root@${ibm_is_floating_ip.awxfip.address}"
}

# Enable Ingress/Inbound ssh on port 22
resource "ibm_is_security_group_rule" "awx_ingress_ssh_all1" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "inbound"
  remote    = "0.0.0.0/0"                     

  tcp = {
    port_min = 22
    port_max = 22
  }
}

# Enable Ingress/Inbound on port 80 for http
resource "ibm_is_security_group_rule" "awx_ingress_http" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "inbound"
  remote    = "0.0.0.0/0" 

  tcp = {
    port_min = 80
    port_max = 80
  }
}


# Enable Ingress/Inbound on port 443 for https
resource "ibm_is_security_group_rule" "awx_egress_https" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "outbound"
  #remote    = "${ibm_is_security_group.sg1.id}"
  remote    = "0.0.0.0/0"

  tcp = {
    port_min = 443
    port_max = 443
  }
}

# Enable egress/outbound on port 80 for http
resource "ibm_is_security_group_rule" "awx_egress_http" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "outbound"
  remote    = "0.0.0.0/0"

  tcp = {
    port_min = 80
    port_max = 80
  }
}

# Enable egress/outbound on port 53 for DNS
resource "ibm_is_security_group_rule" "awx_egress_dns_tcp" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "outbound"
  remote    = "0.0.0.0/0"

  tcp = {
    port_min = 53
    port_max = 53
  }
}

resource "ibm_is_security_group_rule" "awx_egress_dns_udp" {
  group     = "${ibm_is_security_group.awxsg.id}"
  direction = "outbound"
  remote    = "0.0.0.0/0"

  udp = {
    port_min = 53
    port_max = 53
  }
}

