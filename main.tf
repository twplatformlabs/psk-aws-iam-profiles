# Throughout main.tf you will see var.is_state_account used to used to determine whether or not
# the configuration should be applied. Service accounts, groups, and group memberships are defined
# only in the state account. Roles are applied to all accounts. Group membership determines in
# which accounts the identity may assume a role.

# Non-production service account identity ===============================================
# For assuming roles in non-customer facing environments

module "PSKNonprodServiceAccount" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 5.11.1"

  create_user                   = var.is_state_account
  name                          = "PSKNonprodServiceAccount"
  path                          = "/PSKServiceAccounts/"
  create_iam_access_key         = true
  create_iam_user_login_profile = false
  pgp_key                       = var.twdpsio_gpg_public_key_base64
  force_destroy                 = true
  password_reset_required       = false
}

# gpg public key encrypted version of PSKSimpleServiceAccount aws-secret-access-key
output "PSKNonprodServiceAccount_encrypted_aws_secret_access_key" {
  value     = var.is_state_account ? module.PSKNonprodServiceAccount.iam_access_key_encrypted_secret : ""
  sensitive = true
}

output "PSKNonprodServiceAccount_aws_access_key_id" {
  value     = var.is_state_account ? module.PSKNonprodServiceAccount.iam_access_key_id : ""
  sensitive = true
}

# Non-production Group membership defines the nonprod accounts where any role may be assumed
module "PSKNonprodServiceAccountGroup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 5.11.1"

  count           = var.is_state_account ? 1 : 0
  name            = "PSKNonprodServiceAccountGroup"
  assumable_roles = var.all_nonprod_account_roles

  # include the nonprod service account in the nonprod group
  group_users = [
    module.PSKNonprodServiceAccount.iam_user_name
  ]
}


# Production service account identity ====================================================
# For assuming roles in customer facing environments

module "PSKProdServiceAccount" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 5.11.1"

  create_user                   = var.is_state_account
  name                          = "PSKProdServiceAccount"
  path                          = "/PSKServiceAccounts/"
  create_iam_access_key         = true
  create_iam_user_login_profile = false
  pgp_key                       = var.twdpsio_gpg_public_key_base64
  force_destroy                 = true
  password_reset_required       = false
}


# # gpg public key encrypted version of PSKProdServiceAccount aws-secret-access-key
output "PSKProdServiceAccount_encrypted_aws_secret_access_key" {
  value     = var.is_state_account ? module.PSKProdServiceAccount.iam_access_key_encrypted_secret : ""
  sensitive = true
}

output "PSKProdServiceAccount_aws_access_key_id" {
  value     = var.is_state_account ? module.PSKProdServiceAccount.iam_access_key_id : ""
  sensitive = true
}

# Production Group membership defines the production accounts where any role may be assumed
module "PSKProdServiceAccountGroup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "~> 5.11.1"

  count           = var.is_state_account ? 1 : 0
  name            = "PSKProdServiceAccountGroup"
  assumable_roles = concat(var.all_nonprod_account_roles, var.all_production_account_roles)

  # include the production service account in the production group
  group_users = [
    module.PSKProdServiceAccount.iam_user_name
  ]
}
