describe port(8776) do
  it { should be_listening }
  its('processes') { should include 'python' }
end

describe file('/etc/cinder/cinder.conf') do
  its(:content) { should match /mysql:\/\/cinder:/ }
  it { should exist }
end

describe service('cinder-api') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('cinder-scheduler') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
