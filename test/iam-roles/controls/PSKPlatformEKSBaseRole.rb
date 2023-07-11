title "PSK Role for the psk-aws-platform-eks-base pipeline"

describe aws_iam_role(role_name: 'PSKPlatformEKSBaseRole') do
  it { should exist }
end

describe aws_iam_policy(policy_name: 'PSKPlatformEKSBaseRolePolicy') do
  it { should exist }
  its ('attached_roles') { should include 'PSKPlatformEKSBaseRole' }
end
