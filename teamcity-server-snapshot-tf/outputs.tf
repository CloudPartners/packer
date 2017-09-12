output "ebs_snapshot_data" {
  value = "${aws_ebs_snapshot.ebs_snapshot_data.id}"
}

output "ebs_snapshot_artifacts" {
  value = "${aws_ebs_snapshot.ebs_snapshot_artifacts.id}"
}
