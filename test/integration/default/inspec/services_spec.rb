describe port(80) do
  it { should be_listening }
  its('processes') { should include 'apache2' }
end

describe port(3306) do
  it { should be_listening }
  its('processes') { should include 'mysqld' }
end

describe port(5672) do
  it { should be_listening }
  its('processes') { should include 'beam.smp' }
end

describe port(11211) do
  it { should be_listening }
  its('processes') { should include 'memcached' }
end

describe file('/root/passwords2dostuff') do
  it { should exist }
end

describe file('/root/admin-openrc.sh') do
  its(:content) { should match /admin/ }
  it { should exist }
end

describe file('/root/demo-openrc.sh') do
  its(:content) { should match /demo/ }
  it { should exist }
end

describe service('apache2') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('mysql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('rabbitmq-server') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe service('memcached') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
