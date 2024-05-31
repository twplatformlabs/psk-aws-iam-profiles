#!/usr/bin/env bash
source bash-functions.sh
set -eo pipefail

export environment=$1
export aws_account_id=$(jq -er .aws_account_id "$environment".auto.tfvars.json)
export aws_assume_role=$(jq -er .aws_assume_role "$environment".auto.tfvars.json)
export AWS_DEFAULT_REGION=$(jq -er .aws_region "$environment".auto.tfvars.json)

awsAssumeRole "${aws_account_id}" "${aws_assume_role}"

# Rotate AWS IAM User access credentials. https://pypi.org/project/iam-credential-rotation/
echo "rotate service account credentials"
iam-credential-rotation PSKServiceAccounts > machine_credentials.json

# Write new nonprod credentials to 1password
echo "write PSKNonprodServiceAccount credentials"
PSKNonprodServiceAccountCredentials=$(jq -er .PSKNonprodServiceAccount machine_credentials.json)
PSKNonprodAccessKey=$(echo $PSKNonprodServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKNonprodSecret=$(echo $PSKNonprodServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-access-key-id=$PSKNonprodAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-secret-access-key=$PSKNonprodSecret --vault empc-lab >/dev/null

# Write new prod credentials to 1password vault
echo "write PSKProdrodServiceAccount credentials"
PSKProdServiceAccountCredentials=$(jq -er .PSKProdServiceAccount machine_credentials.json)
PSKProdAccessKey=$(echo $PSKProdServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKProdSecret=$(echo $PSKProdServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKProdServiceAccount-aws-access-key-id=$PSKProdAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKProdServiceAccount-aws-secret-access-key=$PSKProdSecret --vault empc-lab >/dev/null
