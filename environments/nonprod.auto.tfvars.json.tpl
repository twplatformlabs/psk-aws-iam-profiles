{
  "aws_region": "us-east-1",
  "aws_account_id": "{{ op://empc-lab/aws-dps-2/aws-account-id }}",

  "is_state_account": true,
  "all_nonprod_account_roles": [
      "arn:aws:iam::{{ op://empc-lab/aws-dps-2/aws-account-id }}:role/*"
  ],
  "all_production_account_roles": [
      "arn:aws:iam::{{ op://empc-lab/aws-dps-1/aws-account-id }}:role/*"
  ]
}
