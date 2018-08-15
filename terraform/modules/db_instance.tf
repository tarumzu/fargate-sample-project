variable "db_user" {}
variable "db_pass" {}
resource "aws_db_instance" "default" {
  // TODO: 本番移行前にスペック見直し
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.39"
  instance_class       = "db.t2.micro"
  // TODO: デフォルトDB名環境移すときに直しとく
  name                 = "mydb"
  username             = "${var.db_user}"
  password             = "${var.db_pass}"
  parameter_group_name = "default.mysql5.6"
  // TODO: 本番移行前にtrueへ
  multi_az = false
  backup_retention_period = "7"
  apply_immediately = true
  auto_minor_version_upgrade = true
  vpc_security_group_ids            = ["${aws_security_group.db.id}"]
}
