locals {
  # AWS Managed policies required for instance to be SSM Managed 
  iam_policies_ssm = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

### Role for EC2 Instance:   Will have policies for ssm and dynamodb
resource "aws_iam_role" "ssm_role" {
  name = "Ec2RoleSsmTerraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF


  # managed_policy_arns = concat(local.iam_policies_ssm, [aws_iam_policy.dynamodb_policy.arn])
  managed_policy_arns = local.iam_policies_ssm

}

# resource "aws_iam_policy" "dynamodb_policy" {

#   name = "dynamo-access"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "dynamodb:Query",
#           "dynamodb:Scan",
#           "dynamodb:GetItem",
#           "dynamodb:PutItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:DeleteItem"
#         ]
#         Effect = "Allow"
#         Resource = [
#           "arn:aws:logs:${var.region}:${local.account_id}:*/*",
#           "arn:aws:dynamodb:${var.region}:${local.account_id}:*/*"
#         ]
#       }
#     ]
#   })
# }

