resource "aws_iam_role" "iam_role" {
  assume_role_policy = "${file("./ecs_assume_role_policy.json")}"
  name = "${var.name}_ecs"
}

resource "aws_iam_role" "execution" {
  assume_role_policy = "${file("./execution_assume_role_policy.json")}"
  name = "${var.name}_execution"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = "${aws_iam_role.iam_role.id}"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = "${aws_iam_role.iam_role.id}"
}
resource "aws_iam_role_policy_attachment" "ecr_power_user" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = "${aws_iam_role.iam_role.id}"
}

data "aws_iam_policy_document" "autoscaling-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["application-autoscaling.amazonaws.com"]
    }
  }
}
