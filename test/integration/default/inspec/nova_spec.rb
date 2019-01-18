describe port(8773) do
  it { should be_listening }
  its('processes') { should include 'python' }
end

describe port(8774) do
  it { should be_listening }
  its('processes') { should include 'python' }
end

describe port(8775) do
  it { should be_listening }
  its('processes') { should include 'python' }
end

describe file('/etc/nova/nova.conf') do
  its(:content) { should match /rabbit_userid = openstack/ }
  it { should exist }
end

describe file('/etc/nova/nova-compute.conf') do
  its(:content) { should match /virt_type=qemu/ }
  it { should exist }
end

describe service('nova-api') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-cert') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-compute') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-conductor') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-consoleauth') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-novncproxy') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('nova-scheduler') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
