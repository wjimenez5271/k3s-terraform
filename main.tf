provider "aws" {
  region = "us-west-2"
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

data "template_file" "cloud-config-server" {
  template = "${file("${path.module}/cloud-config-server.yml")}"

  vars {
    k3s_cluster_secret  = "${var.k3s_cluster_secret}"
    install_k3s_version = "${var.install_k3s_version}"
  }
}

resource "aws_instance" "server" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.ec2_instance_type}"
  user_data              = "${data.template_file.cloud-config-server.rendered}"
  key_name               = "${var.ssh_keypair}"
  vpc_security_group_ids = ["${aws_security_group.instances.id}"]

  tags = {
    Name = "${var.resource_prefix}-k3s-server"
  }
}

data "template_file" "cloud-config-worker" {
  template = "${file("${path.module}/cloud-config-worker.yml")}"

  vars {
    k3s_url             = "${var.k3s_url}"
    k3s_cluster_secret  = "${var.k3s_cluster_secret}"
    install_k3s_version = "${var.install_k3s_version}"
  }
}

resource "aws_instance" "worker" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.ec2_instance_type}"
  user_data              = "${data.template_file.cloud-config-worker.rendered}"
  key_name               = "${var.ssh_keypair}"
  vpc_security_group_ids = ["${aws_security_group.instances.id}"]

  tags = {
    Name = "${var.resource_prefix}-k3s-worker"
  }
}
