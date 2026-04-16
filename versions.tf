terraform {
  required_version = "~> 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40"
    }
  }

  # The backend cloud store is managed using the terraform orb tfc-backend command.
  # this command will generate the appropriate template for the tf workspace:
  #
  # terraform {
  #   cloud {
  #     organization = "${TFC_ORGANIZATION}"
  #     hostname = "app.terraform.io"

  #     workspaces {
  #       name = "${TFC_WORKSPACE}"
  #     }
  #   }
  # }

}

provider "aws" {
  region = var.aws_region

  # this section commented out during the initial bootstrap run.
  # once the assumeable roles are created, uncomment and change
  # op.*.env to contain the appropriate service account identity
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_assume_role}"
    session_name = "psk-aws-iam-profiles"
  }

  default_tags {
    tags = {
      product  = "empc engineering platform"
      pipeline = "psk-aws-iam-profiles"
    }
  }
}
