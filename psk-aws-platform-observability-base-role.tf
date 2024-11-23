# PSKPlatformObservabilityBaseRole
#
# Used by: psk-aws-iam-profiles pipeline
# manages iam policy for platform roles, groups, and service accounts

module "PSKPlatformObservabilityBaseRole" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version     = "5.48.0"
  create_role = true

  role_name                         = "PSKPlatformObservabilityBaseRole"
  role_path                         = "/PSKRoles/"
  role_requires_mfa                 = false
  custom_role_policy_arns           = [aws_iam_policy.PSKPlatformObservabilityBaseRolePolicy.arn]
  number_of_custom_role_policy_arns = 1

  trusted_role_arns = ["arn:aws:iam::${var.state_account_id}:root"]
}

# role permissions
resource "aws_iam_policy" "PSKPlatformObservabilityBaseRolePolicy" {
  name = "PSKPlatformObservabilityBaseRolePolicy"
  path = "/PSKPolicies/"

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:DeleteLogGroup",
          "logs:ListTagsLogGroup",
          "logs:PutRetentionPolicy",
          "logs:TagLogGroup",
          "logs:UntagLogGroup",
          "aps:*"
        ]
        "Effect" : "Allow"
        "Resource" : "*"
      },
    ]
  })
}
