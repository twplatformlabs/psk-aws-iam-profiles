# PSKIamProfilesRole
#
# Used by: psk-aws-iam-profiles pipeline
# manages iam policy for platform roles, groups, and service accounts

module "PSKIamProfilesRole" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  #checkov:skip=CKV_TF_1
  version     = "5.37.1"
  create_role = true

  role_name                         = "PSKIamProfilesRole"
  role_path                         = "/PSKRoles/"
  role_requires_mfa                 = false
  custom_role_policy_arns           = [aws_iam_policy.PSKIamProfilesRolePolicy.arn]
  number_of_custom_role_policy_arns = 1

  trusted_role_arns = ["arn:aws:iam::${var.state_account_id}:root"]
}

# role permissions
#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "PSKIamProfilesRolePolicy" {
  name = "PSKIamProfilesRolePolicy"
  path = "/PSKPolicies/"

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Action" : [
          "iam:AddUserToGroup",
          "iam:AttachGroupPolicy",
          "iam:AttachRolePolicy",
          "iam:AttachUserPolicy",
          "iam:ChangePassword",
          "iam:CreateAccessKey",
          "iam:CreateAccountAlias",
          "iam:CreateGroup",
          "iam:CreateLoginProfile",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:CreateRole",
          "iam:CreateUser",
          "iam:DeleteAccessKey",
          "iam:DeleteGroup",
          "iam:DeleteGroupPolicy",
          "iam:DeleteLoginProfile",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DeleteSSHPublicKey",
          "iam:DeleteUser",
          "iam:DeleteUserPolicy",
          "iam:DetachGroupPolicy",
          "iam:DetachRolePolicy",
          "iam:DetachUserPolicy",
          "iam:GetAccessKeyLastUsed",
          "iam:GetContextKeysForCustomPolicy",
          "iam:GetContextKeysForPrincipalPolicy",
          "iam:GetGroup",
          "iam:GetGroupPolicy",
          "iam:GetLoginProfile",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:GetSSHPublicKey",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:ListAccessKeys",
          "iam:ListAccountAliases",
          "iam:ListAttachedGroupPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListAttachedUserPolicies",
          "iam:ListEntitiesForPolicy",
          "iam:ListGroupPolicies",
          "iam:ListGroups",
          "iam:ListGroupsForUser",
          "iam:ListInstanceProfiles",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicies",
          "iam:ListPolicyVersions",
          "iam:ListRolePolicies",
          "iam:ListRoles",
          "iam:ListSSHPublicKeys",
          "iam:ListUserPolicies",
          "iam:ListUsers",
          "iam:PutGroupPolicy",
          "iam:PutRolePolicy",
          "iam:PutUserPolicy",
          "iam:RemoveUserFromGroup",
          "iam:SetDefaultPolicyVersion",
          "iam:SimulateCustomPolicy",
          "iam:SimulatePrincipalPolicy",
          "iam:UpdateAccessKey",
          "iam:UpdateAssumeRolePolicy",
          "iam:UpdateGroup",
          "iam:UpdateLoginProfile",
          "iam:UpdateSSHPublicKey",
          "iam:UpdateUser",
          "iam:UploadSSHPublicKey",
          "iam:Tag*",
          "iam:ListMFADevices"
        ]
        "Effect" : "Allow"
        "Resource" : "*"
      },
    ]
  })
}
