provider "aws" {
  region  = "${var.aws_region}"
  profile = "default"
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["teamcity-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${data.aws_caller_identity.current.account_id}"]
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["DELTA1"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["DELTA1-PUBLIC-1"]
  }
}

resource "aws_security_group" "teamcity_services" {
  name        = "teamcity_services"
  description = "TeamCity Services Rules"
  vpc_id      = "${data.aws_vpc.selected.id}"

  tags {
    Name = "teamcity_services"
  }
}

resource "aws_security_group_rule" "teamcity_services-01" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.teamcity_services.id}"
}

resource "aws_security_group_rule" "teamcity_services-02" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.teamcity_services.id}"
}

resource "aws_security_group_rule" "teamcity_services-03" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.teamcity_services.id}"
}

data "template_file" "teamcity_server" {
  template = "${file("${path.module}/userdata/teamcity_server_userdata.sh")}"

  vars {
    region = "${var.aws_region}"
  }
}

resource "aws_spot_instance_request" "teamcity" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "c4.xlarge"
  spot_price             = "0.0723"
  spot_type              = "one-time"
  subnet_id              = "${data.aws_subnet.selected.id}"
  ebs_optimized          = true
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.teamcity_services.id}"]
  wait_for_fulfillment   = true
  key_name               = "devops-infrastructure"
  user_data              = "${data.template_file.teamcity_server.rendered}"

  tags {
    Name = "TeamCity Server"
  }
}

data "aws_instance" "teamcity" {
  filter {
    name   = "spot-instance-request-id"
    values = ["${aws_spot_instance_request.teamcity.id}"]
  }
}

data "aws_ebs_snapshot" "ebs_snapshot_data" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["TeamCity Data"]
  }
}

resource "aws_ebs_volume" "ebs_volume_data" {
  availability_zone = "eu-west-1a"
  snapshot_id       = "${data.aws_ebs_snapshot.ebs_snapshot_data.id}"
  type              = "gp2"

  tags {
    Name = "TeamCity Data"
  }
}

resource "aws_volume_attachment" "volume_attachment_data" {
  device_name  = "/dev/xvdf"
  volume_id    = "${aws_ebs_volume.ebs_volume_data.id}"
  instance_id  = "${data.aws_instance.teamcity.id}"
  skip_destroy = true
}

data "aws_ebs_snapshot" "ebs_snapshot_artifacts" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["TeamCity Artifacts"]
  }
}

resource "aws_ebs_volume" "ebs_volume_artifacts" {
  availability_zone = "eu-west-1a"
  snapshot_id       = "${data.aws_ebs_snapshot.ebs_snapshot_artifacts.id}"
  type              = "gp2"

  tags {
    Name = "TeamCity Artifacts"
  }
}

resource "aws_volume_attachment" "volume_attachment_artifacts" {
  device_name  = "/dev/xvdg"
  volume_id    = "${aws_ebs_volume.ebs_volume_artifacts.id}"
  instance_id  = "${data.aws_instance.teamcity.id}"
  skip_destroy = true
}
