describe port(8443) do
  it { should be_listening }
  its('processes') { should eq 'apache2' }
end

describe file('/etc/openstack-dashboard/local_settings.py') do
  it { should exist }
end
