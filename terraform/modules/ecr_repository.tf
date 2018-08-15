resource "aws_ecr_repository" "ecr" {
  name = "${var.name}-rails"
}

resource "aws_ecr_lifecycle_policy" "policy" {
  repository = "${aws_ecr_repository.ecr.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 150 images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 150
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
