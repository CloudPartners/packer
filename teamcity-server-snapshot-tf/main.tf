provider "aws" {
  region  = "${var.aws_region}"
  profile = "default"
}

data "aws_ebs_volume" "ebs_volume_data" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:Name"
    values = ["TeamCity Data"]
  }
}

resource "aws_ebs_snapshot" "ebs_snapshot_data" {
  volume_id   = "${data.aws_ebs_volume.ebs_volume_data.id}"
  description = "TeamCity Data"

  tags {
    Name = "TeamCity Data"
  }
}

data "aws_ebs_volume" "ebs_volume_artifacts" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "tag:Name"
    values = ["TeamCity Artifacts"]
  }
}

resource "aws_ebs_snapshot" "ebs_snapshot_artifacts" {
  volume_id   = "${data.aws_ebs_volume.ebs_volume_artifacts.id}"
  description = "TeamCity Artifacts"

  tags {
    Name = "TeamCity Artifacts"
  }
}
