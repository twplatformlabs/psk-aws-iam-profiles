#!/usr/bin/env bash
export ENVIRONMENT=$1
export AWS_ACCOUNT_ID=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_account_id)
export AWS_ASSUME_ROLE=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_assume_role)

aws sts assume-role --output json --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_ASSUME_ROLE} --role-session-name psk-aws-iam-profiles > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

echo "rotate service account credentials"
iam-credential-rotation PSKServiceAccounts > machine_credentials.json

echo "write PSKNonprodServiceAccount credentials"
PSKNonprodServiceAccountCredentials=$(cat machine_credentials.json | jq .PSKNonprodServiceAccount)
op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-access-key-id=$(echo $PSKNonprodServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n) >/dev/null
op item edit 'aws-dps-2' PSKNonprodServiceAccount-aws-secret-access-key=$(echo $PSKNonprodServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n) >/dev/null

echo "write PSKProdrodServiceAccount credentials"
PSKProdServiceAccountCredentials=$(cat machine_credentials.json | jq .PSKProdServiceAccount)
op item edit 'aws-dps-2' PSKProdServiceAccount-aws-access-key-id=$(echo $PSKProdServiceAccountCredentials | jq .AccessKeyId | sed 's/"//g' | tr -d \\n) >/dev/null
op item edit 'aws-dps-2' PSKProdServiceAccount-aws-secret-access-key=$(echo $PSKProdServiceAccountCredentials | jq .SecretAccessKey | sed 's/"//g' | tr -d \\n) >/dev/null
