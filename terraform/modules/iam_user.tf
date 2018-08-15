resource "aws_iam_user" "user" {
  name = "sample-project-deployer"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}

resource "aws_iam_policy" "policy" {
  name        = "sample-project-policy"
  description = "sample-project policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::sample-project"
          ],
          "Condition": {
              "StringEquals": {
                  "s3:prefix": [
                      ""
                  ]
              }
          }
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket"
          ],
          "Resource": [
              "arn:aws:s3:::sample-project"
          ],
          "Condition": {
              "StringLike": {
                  "s3:prefix": [
                      "production",
                      "production/*"
                  ]
              }
          }
      },
      {
          "Effect": "Allow",
          "Action": [
              "s3:*"
          ],
          "Resource": [
              "arn:aws:s3:::sample-project/production/*"
          ]
      }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "attachment"
  users      = ["${aws_iam_user.user.id}"]
  roles      = ["${aws_iam_role.iam_role.id}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}
resource "aws_iam_policy_attachment" "attach2" {
  name       = "attachment2"
  users      = ["${aws_iam_user.user.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
}
resource "aws_iam_policy_attachment" "attach3" {
  name       = "attachment3"
  users      = ["${aws_iam_user.user.id}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
