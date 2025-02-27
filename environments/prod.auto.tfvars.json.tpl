{
  "aws_region": "us-east-1",
  "aws_account_id": "{{ op://platform/aws-production/aws-account-id }}",
  "aws_assume_role": "PSKRoles/PSKIamProfilesRole",

  "is_state_account": false,
  "state_account_id": "{{ op://platform/aws-sandbox/aws-account-id }}",
  "all_nonprod_account_roles": [
      "arn:aws:iam::{{ op://platform/aws-sandbox/aws-account-id }}:role/PSKRoles/*"
  ],
  "all_production_account_roles": [
      "arn:aws:iam::{{ op://platform/aws-production/aws-account-id }}:role/PSKRoles/*"
  ]
}
