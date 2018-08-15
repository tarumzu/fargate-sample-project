variable "access_key" {}
variable "secret_key" {}
variable "token" {}
variable "db_user" {}
variable "db_pass" {}
variable "region" { default = "ap-northeast-1"}

terraform {
  backend "s3" {
    bucket = "sample-project"  //e.g. terraform-state-bucket
    key    = "sample-project.terraform.tfstate"
    region     = "ap-northeast-1"
    profile = "sample" // s3にアクセスできるアカウントでawsのプロファイルを作成する！
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  token = "${var.token}"
  region     = "${var.region}"
}


module "pro" {
  region                            = "${var.region}"
  db_user                           = "${var.db_user}"
  db_pass                           = "${var.db_pass}"
  source = "./modules"
}
