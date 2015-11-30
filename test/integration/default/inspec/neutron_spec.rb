describe port(9696) do
  it { should be_listening }
  its('process') { should eq 'python' }
end

describe service('neutron-dhcp-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('neutron-l3-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('neutron-metadata-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('neutron-plugin-linuxbridge-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
