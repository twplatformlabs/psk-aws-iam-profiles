# PSKPlatformObservabilityBaseRole
#
# Used by: psk-aws-iam-profiles pipeline
# manages iam policy for platform roles, groups, and service accounts

module "PSKPlatformObservabilityBaseRole" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.2.3"
  create  = true

  name            = "PSKPlatformObservabilityBaseRole"
  path            = "/PSKRoles/"
  use_name_prefix = false

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      actions = [
        "sts:TagSession",
        "sts:AssumeRole",
      ]
      principals = [{
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${var.state_account_id}:root",
        ]
      }]
    }
  }

  policies = {
    custom = aws_iam_policy.PSKPlatformObservabilityBaseRolePolicy.arn
  }
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
