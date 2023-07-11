title "PSK Role for the psk-aws-platform-vpc pipeline"

describe aws_iam_role(role_name: 'PSKPlatformWANRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'PSKPlatformWANRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'PSKPlatformWANRole' }
end
