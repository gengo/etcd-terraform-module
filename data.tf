data "aws_route53_zone" "selected" {
  zone_id = "${var.route53_zone_id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_subnet" "etcd-subnet" {
  id = "${element(var.subnet_ids, 0)}"
}

data "aws_vpc" "main" {
  id = "${data.aws_subnet.etcd-subnet.vpc_id}"
}
