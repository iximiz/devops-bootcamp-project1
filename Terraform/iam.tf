data "aws_iam_role" "ec2_ssm_role" {
  name = "EC2-SSM-Role"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "devops-ec2-ssm-profile"
  role = data.aws_iam_role.ec2_ssm_role.name

  tags = {
    Name = "devops-ec2-ssm-profile"
  }
}

resource "aws_iam_role_policy" "ansible_ssm" {
  name = "devops-ansible-ssm"
  role = data.aws_iam_role.ec2_ssm_role.name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:StartSession"
        ]

        Resource = [
          "arn:aws:ssm:ap-southeast-1:585242447690:document/SSM-SessionManagerRunShell",
          "arn:aws:ec2:ap-southeast-1:585242447690:instance/i-0bfbcd6645ab871aa",
          "arn:aws:ec2:ap-southeast-1:585242447690:instance/i-0fa21ebee25cd99d8"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "ssm:TerminateSession",
          "ssm:ResumeSession"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_pull" {
  name = "devops-ecr-pull"
  role = data.aws_iam_role.ec2_ssm_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "arn:aws:ecr:ap-southeast-1:585242447690:repository/devops-bootcamp/final-project-amirul"
      }
    ]
  })
}