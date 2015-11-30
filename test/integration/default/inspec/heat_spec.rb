describe port(8000) do
  it { should be_listening }
  its('process') { should eq 'python' }
end

describe port(8004) do
  it { should be_listening }
  its('process') { should eq 'python' }
end

describe file('/etc/heat/heat.conf') do
  its(:content) { should match /mysql:\/\/heat:/ }
  it { should exist }
end

describe service('heat-api') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('heat-api-cfn') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('heat-engine') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
