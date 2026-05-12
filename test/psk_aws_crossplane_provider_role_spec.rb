require 'awspec'

describe iam_role('PSKCrossplaneProviderRole') do
  it { should exist }
end