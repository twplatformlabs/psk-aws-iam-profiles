variable "aws_region" {
  description = "default aws region"
  type        = string
}

variable "aws_account_id" {
  description = "default aws account id"
  type        = string

  validation {
    condition     = length(var.aws_account_id) == 12 && can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "Invalid AWS account ID"
  }
}

variable "is_state_account" {
  description = "create STATE account configuration"
  type        = bool
  default     = false
}

variable "all_nonprod_account_roles" {
  description = "arn reference to * roles for all non-production aws accounts; arn:aws:iam::*****12345:role/*"
  type        = list(any)
}

variable "all_production_account_roles" {
  description = "arn reference to * roles for all production aws accounts; arn:aws:iam::*****12345:role/*"
  type        = list(any)
}



# # ========= original

# # is the plan/apply running against the profiles account?
# variable "is_state_account" {
#   type     = bool
#   default  = false
# }

# variable "aws_region" {}
# variable "assume_role" {}

# variable "account_id" {
#   type        = string
#   sensitive   = true
# }

# variable "prod_account_id" {
#   type        = string
#   sensitive   = true
# }

# variable "nonprod_account_id" {
#   type        = string
#   sensitive   = true
# }

# variable "datadog_api_key" {
#   type        = string
#   sensitive   = true
# }

# variable "datadog_app_key" {
#   type        = string
#   sensitive   = true
# }


# # twdps.io@gmail.com service account gpg public key for encrypting aws credentials
# # not a secret, but even public keys can set off secret scanners
# variable "twdpsio_gpg_public_key_base64" {
#   type        = string
#   sensitive   = true
# }

# # ========= new

# variable "is_prod_account" {}
# variable "aws_default_region" {}
# variable "aws_account_role" {}

# variable "aws_account_id" {
#   type        = string
#   sensitive   = true
# }
# variable "all_nonprod_account_roles" {}
# variable "all_production_account_roles" {}
