resource "aws_subnet" "public_a" {
  availability_zone = "${var.region}a"
  cidr_block        = "${var.subnet_public_a}"
  vpc_id            = "${var.vpc_id}"
}

resource "aws_subnet" "public_c" {
  availability_zone = "${var.region}c"
  cidr_block        = "${var.subnet_public_c}"
  vpc_id            = "${var.vpc_id}"
}
