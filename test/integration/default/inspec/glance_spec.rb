describe port(9191) do
  it { should be_listening }
  its('processes') { should eq 'python' }
end

describe port(9292) do
  it { should be_listening }
  its('processes') { should eq 'python' }
end

describe file('/etc/glance/glance-api.conf') do
  its(:content) { should match /flavor=keystone/ }
  it { should exist }
end

describe file('/etc/glance/glance-registry.conf') do
  its(:content) { should match /flavor=keystone/ }
  it { should exist }
end

describe service('glance-api') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('glance-registry') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
