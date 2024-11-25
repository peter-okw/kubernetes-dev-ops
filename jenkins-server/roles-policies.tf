resource "aws_iam_role" "jenkins-role" {
  name               = "jenkins-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam-policy" {
  role = aws_iam_role.jenkins-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "Jenkins-instance-profile" {
  name = "Jenkins-instance-profile"
  role = aws_iam_role.jenkins-role.name
}

