# Throughout main.tf you will see var.is_state_account used to determine whether or not
# the configuration should be applied. Service accounts, groups, and group memberships are defined
# only in the state account. Roles are applied to all accounts. Group membership determines in
# which accounts the identity may assume a role.

# Non-production service account identity ===============================================
# For assuming roles in non-production and also non-customer facing environments. A separate pipeline step
# will create and store the service account credentials in the secrets store

module "PSKNonprodServiceAccount" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.2.3"

  create                  = var.is_state_account
  name                    = "PSKNonprodServiceAccount"
  path                    = "/PSKServiceAccounts/"
  create_access_key       = false
  create_login_profile    = false
  force_destroy           = true
  password_reset_required = false
}

module "PSKNonprodServiceAccountGroup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "6.2.3"

  create = var.is_state_account
  name   = "PSKNonprodServiceAccountGroup"
  path   = "/PSKGroups/"

  enable_self_management_permissions = false
  permissions = {
    AssumeRole = {
      actions   = ["sts:AssumeRole"]
      resources = var.all_nonprod_account_roles
    }
  }

  # include the nonprod service account in the nonprod group
  users = [
    module.PSKNonprodServiceAccount.name
  ]
}

# Production service account identity ====================================================
# For assuming roles in all environments (including customer facing). A separate pipeline step
# will create and store the service account credentials in the secrets store

module "PSKProdServiceAccount" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "6.2.3"

  create                  = var.is_state_account
  name                    = "PSKProdServiceAccount"
  path                    = "/PSKServiceAccounts/"
  create_access_key       = false
  create_login_profile    = false
  force_destroy           = true
  password_reset_required = false
}

module "PSKProdServiceAccountGroup" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group"
  version = "6.2.3"

  create = var.is_state_account
  name   = "PSKProdServiceAccountGroup"
  path   = "/PSKGroups/"

  enable_self_management_permissions = false
  permissions = {
    AssumeRole = {
      actions   = ["sts:AssumeRole"]
      resources = concat(var.all_nonprod_account_roles, var.all_production_account_roles)
    }
  }

  # include the production service account in the production group
  users = [
    module.PSKProdServiceAccount.name
  ]
}
