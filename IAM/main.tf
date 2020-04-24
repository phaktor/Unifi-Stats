resource "aws_iam_role" "SSM-UnifiPoller-ROLE" {
  name = "SSM-UnifiPoller-ROLE"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path = "/"
}

data "aws_iam_policy" "SSM-Policy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "SSM-Role-Attachment" {
  name       = "SSM-Role-Attachment"
  roles      = [aws_iam_role.SSM-UnifiPoller-ROLE.name]
  policy_arn = data.aws_iam_policy.SSM-Policy.arn
}

resource "aws_iam_instance_profile" "SSM-Instance-Profile" {
  name = "SSM-UnifiPoller-Instance-Profile"
  role = aws_iam_role.SSM-UnifiPoller-ROLE.id
}