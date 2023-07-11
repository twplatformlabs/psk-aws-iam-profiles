title "PSK Role for the psk-aws-platform-vpc pipeline"

describe aws_iam_role(role_name: 'PSKPlatformVPCRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'PSKPlatformVPCRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'PSKPlatformVPCRole' }
end
