title "PSK Role for the psk-aws-iam-profiles pipeline"

describe aws_iam_role(role_name: 'PSKIamProfilesRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'PSKIamProfilesRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'PSKIamProfilesRole' }
end
