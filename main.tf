resource "aws_instance" "etcd" {
  count                       = "${var.count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  key_name                    = "${var.key_name}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = true
  subnet_id                   = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids      = ["${split(",", format("%s,%s", join(",", var.security_group_ids), aws_security_group.etcd_internal.id))}"]
  tags {
    Name="${format("${var.hostname}-0%01d",count.index+1)}"
  }

  provisioner "remote-exec" {
    inline = ["ls"]
    connection {
      type        = "ssh"
      private_key = "${file(format("~/.ssh/%s.pem", var.key_name))}"
      user        = "ubuntu"
    }
  }
}

resource "aws_route53_record" "etcd" {
  count   = "${var.count}"

  name    = "${format("${var.hostname}-0%01d", count.index + 1)}.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${element(aws_instance.etcd.*.public_dns, count.index)}"]
  zone_id = "/hostedzone/${data.aws_route53_zone.selected.id}"
}

resource "null_resource" "provision" {
  count   = "${var.count}"

  depends_on = ["aws_instance.etcd", "aws_route53_record.etcd"]
  provisioner "local-exec" {
    working_dir = "/srv/devops-tools/daidokoro"

    command = "${format(
      "knife solo bootstrap ubuntu@%s nodes/${var.hostname}-0%01d.%s.json -i ~/.ssh/%s.pem",
      element(aws_instance.etcd.*.public_dns, count.index),
      count.index + 1,
      replace(data.aws_route53_zone.selected.name, "/\\.$/", ""),
      var.key_name
    )}"
  }
}
