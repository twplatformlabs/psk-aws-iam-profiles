require 'awspec'

describe iam_role('PSKIamProfilesRole') do
  it { should exist }
  it { should have_iam_policy('PSKIamProfilesRolePolicy') }
end

describe iam_role('PSKPlatformWANRole') do
  it { should exist }
  it { should have_iam_policy('PSKPlatformWANRolePolicy') }
end

describe iam_role('PSKPlatformVPCRole') do
  it { should exist }
  it { should have_iam_policy('PSKPlatformVPCRolePolicy') }
end

describe iam_role('PSKPlatformEKSBaseRole') do
  it { should exist }
  it { should have_iam_policy('PSKPlatformEKSBaseRolePolicy') }
end
