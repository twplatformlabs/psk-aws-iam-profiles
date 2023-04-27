# frozen_string_literal: true

title 'EMPC Labs - PSK AWS Service Account Profiles'

describe aws_iam_user(user_name: 'PSKNonprodServiceAccount') do
it { should exist }
end

describe aws_iam_user(user_name: 'PSKProdServiceAccount') do
it { should exist }
end

describe aws_iam_group(group_name: 'PSKNonprodServiceAccountGroup') do
  it { should exist }
  its('users') { should include('PSKNonprodServiceAccount') }
end

describe aws_iam_group(group_name: 'PSKProdServiceAccountGroup') do
  it { should exist }
  its('users') { should include('PSKProdServiceAccount') }
end
