#!/usr/bin/env bash
export ENVIRONMENT=$1
export AWS_ACCOUNT_ID=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_account_id)
export AWS_ASSUME_ROLE=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_assume_role)

aws sts assume-role --output json --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_ASSUME_ROLE} --role-session-name psk-aws-iam-profiles > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

# Rotate AWS IAM User access credentials. https://pypi.org/project/iam-credential-rotation/
echo "rotate service account credentials"
iam-credential-rotation PSKServiceAccounts > machine_credentials.json

# Write new nonprod credentials to 1password
echo "write PSKNonprodServiceAccount credentials"
PSKNonprodServiceAccountCredentials=$(cat machine_credentials.json | jq .PSKNonprodServiceAccount)
PSKNonprodAccessKey=$(echo $PSKNonprodServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKNonprodSecret=$(echo $PSKNonprodServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-access-key-id=$PSKNonprodAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-secret-access-key=$PSKNonprodSecret --vault empc-lab >/dev/null

# Write new prod credentials to 1password
echo "write PSKProdrodServiceAccount credentials"
PSKProdServiceAccountCredentials=$(cat machine_credentials.json | jq .PSKProdServiceAccount)
PSKProdAccessKey=$(echo $PSKProdServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n)
PSKProdSecret=$(echo $PSKProdServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n)

op item edit 'aws-dps-2' PSKProdServiceAccount-aws-access-key-id=$PSKProdAccessKey --vault empc-lab >/dev/null
op item edit 'aws-dps-2' PSKProdServiceAccount-aws-secret-access-key=$PSKProdSecret --vault empc-lab >/dev/null
