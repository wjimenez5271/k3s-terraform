resource "aws_security_group" "instances" {
  name        = "k3s-${var.resource_prefix}"
  description = "k3s-${var.resource_prefix}"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}

resource "aws_security_group_rule" "inbound_allow_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instances.id}"
}

resource "aws_security_group_rule" "kubeapi" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  self              = true
  security_group_id = "${aws_security_group.instances.id}"
}
