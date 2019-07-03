resource "aws_security_group" "etcd_internal" {
  name        = "${var.hostname}-internal"
  vpc_id      = "${data.aws_subnet.etcd-subnet.vpc_id}"
  description = "Allows etcd access internally"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.hostname}-internal"
  }
}

resource "aws_security_group_rule" "ssh_to_etcd" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.etcd_internal.id}"
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  description              = "SSH to ETCD"
}

resource "aws_security_group_rule" "nodes_to_etcd_2380" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.etcd_internal.id}"
  cidr_blocks              = ["${data.aws_vpc.main.cidr_block}"]
  from_port                = 2380
  to_port                  = 2380
  protocol                 = "tcp"
  description              = "Internal Instances to ETCD"
}

resource "aws_security_group_rule" "nodes_to_etcd_2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.etcd_internal.id}"
  cidr_blocks              = ["${data.aws_vpc.main.cidr_block}"]
  from_port                = 2379
  to_port                  = 2379
  protocol                 = "tcp"
  description              = "Internal Instances to ETCD"
}
