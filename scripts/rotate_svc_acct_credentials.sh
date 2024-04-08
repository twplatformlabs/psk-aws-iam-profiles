#!/usr/bin/env bash
source bash-functions.sh
set -eo pipefail

export ENVIRONMENT=$1
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

awsAssumeRole $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_account_id) $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_assume_role)

# export AWS_ACCOUNT_ID=$(jq -r .aws_account_id < ${ENVIRONMENT}.auto.tfvars.json)
# export AWS_ASSUME_ROLE=$(jq -r .aws_assume_role < ${ENVIRONMENT}.auto.tfvars.json)

# aws sts assume-role --output json --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_ASSUME_ROLE} --role-session-name psk-aws-iam-profiles > credentials

# export AWS_ACCESS_KEY_ID=$(jq -r ".Credentials.AccessKeyId" < credentials)
# export AWS_SECRET_ACCESS_KEY=$(jq -r ".Credentials.SecretAccessKey" < credentials)
# export AWS_SESSION_TOKEN=$(jq -r ".Credentials.SessionToken" < credentials)

# Rotate AWS IAM User access credentials. https://pypi.org/project/iam-credential-rotation/
echo "rotate service account credentials"
iam-credential-rotation PSKServiceAccounts > machine_credentials.json

# Write new nonprod credentials to 1password
echo "write PSKNonprodServiceAccount credentials"
PSKNonprodServiceAccountCredentials=$(jq .PSKNonprodServiceAccount < machine_credentials.json)
PSKNonprodAccessKey=$(echo $PSKNonprodServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKNonprodSecret=$(echo $PSKNonprodServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-access-key-id=$PSKNonprodAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-secret-access-key=$PSKNonprodSecret --vault empc-lab >/dev/null

# Write new prod credentials to 1password vault
echo "write PSKProdrodServiceAccount credentials"
PSKProdServiceAccountCredentials=$(jq .PSKProdServiceAccount <  machine_credentials.json)
PSKProdAccessKey=$(echo $PSKProdServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKProdSecret=$(echo $PSKProdServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKProdServiceAccount-aws-access-key-id=$PSKProdAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKProdServiceAccount-aws-secret-access-key=$PSKProdSecret --vault empc-lab >/dev/null
