describe port(443) do
  it { should be_listening }
  its('processes') { should include 'apache2' }
end

describe file('/etc/openstack-dashboard/local_settings.py') do
  it { should exist }
end
