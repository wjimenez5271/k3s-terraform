variable "vpc_id" {}
variable "ssh_keypair" {}
variable "resource_prefix" {}
variable "k3s_url" {}
variable "k3s_cluster_secret" {}
variable "install_k3s_version" {}

variable "ec2_instance_type" {
  default = "t2.xlarge"
}
