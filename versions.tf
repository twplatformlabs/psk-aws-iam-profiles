terraform {
  # pin major.minor versions
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61"
    }
  }

  # Remote backend state using terraform cloud
  # Note: the `prefix` workspace configuration creates a separate state store for
  # each environment. These must be pre-created using the terraform cli. In addition,
  # after creating a workspace you must access the app.terraform.io UI and set the
  # workspace to type `local`.
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "twdps"
    workspaces {
      prefix = "psk-aws-iam-profiles-"
    }
  }
}



provider "aws" {
  region = var.aws_region

  # this section commented out during the initial bootstrap run
  # once the assumeable roles are created, uncomment and change
  # secrethub.*.env to contain the appropriate service account identity
  # assume_role {
  #   role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_account_role}"
  #   session_name = "lab-iam-profiles"
  # }

  default_tags {
    tags = {
      pipeline = "psk-aws-iam-profiles"
    }
  }
}
