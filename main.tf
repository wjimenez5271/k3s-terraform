provider "aws" {region = "us-west-2"}

variable "vpc_id" {
}

variable "ssh_keypair" {
}

variable "resource_prefix" {
  
}

variable "ec2_instance_type" {
  default = "t2.xlarge"
}


resource "aws_security_group" "instances" {
  name        = "k3s-${var.resource_prefix}"
  description = "k3s-${var.resource_prefix}"
  vpc_id      = "${var.vpc_id}"
  }

resource "aws_security_group_rule" "ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "TCP"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}
resource "aws_security_group_rule" "outbound_allow_all" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}

resource "aws_security_group_rule" "inbound_allow_all" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}

resource "aws_security_group_rule" "kubeapi" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "TCP"
  self            = true  
  security_group_id = "${aws_security_group.instances.id}"

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"] # Ubuntu Minimal Bionic
    }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  }

resource "aws_instance" "server" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.ec2_instance_type}"
  user_data = "${file("cloud-config-server.yml")}"
  key_name = "${var.ssh_keypair}"
  vpc_security_group_ids = ["${aws_security_group.instances.id}"]
  tags = {
    Name = "${var.resource_prefix}-k3s-server"
  }
}

resource "aws_instance" "worker" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.ec2_instance_type}"
  user_data = "${file("cloud-config-worker.yml")}"
  key_name = "${var.ssh_keypair}"
  vpc_security_group_ids = ["${aws_security_group.instances.id}"]
  tags = {
    Name = "${var.resource_prefix}-k3s-worker"
  }
}
