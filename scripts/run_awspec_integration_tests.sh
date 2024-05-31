#!/usr/bin/env bash
source bash-functions.sh
set -eo pipefail

export ENVIRONMENT=$1
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

awsAssumeRole $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_account_id) $(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_assume_role)

# test roles
rspec test/*.rb --format documentation

# if this is the state account then test the profiles
if [[ ${ENVIRONMENT} == "nonprod" ]]; then
  rspec test/state-account/psk_aws_service_accounts_spec.rb --format documentation
fi


# export environment=$1
# export aws_account_id=$(jq -er .aws_account_id "$environment".auto.tfvars.json)
# export aws_assume_role=$(jq -er .aws_assume_role "$environment".auto.tfvars.json)
# export AWS_DEFAULT_REGION=$(jq -er .aws_region "$environment".auto.tfvars.json)

# awsAssumeRole "${aws_assume_role}" "${aws_account_id}"

# # test roles
# rspec test/*.rb --format documentation

# # if this is the state account then test the profiles
# if [[ ${environment} == "nonprod" ]]; then
#   rspec test/state-account/psk_aws_service_accounts_spec.rb --format documentation
# fi
