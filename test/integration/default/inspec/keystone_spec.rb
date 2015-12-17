describe port(5000) do
  it { should be_listening }
  its('processes') { should eq 'apache2' }
end

describe port(35357) do
  it { should be_listening }
  its('processes') { should eq 'apache2' }
end

describe file('/etc/keystone/keystone.conf') do
  it { should exist }
end

describe file('/etc/apache2/sites-available/wsgi-keystone.conf') do
  it { should exist }
end

describe file('/etc/apache2/sites-enabled/wsgi-keystone.conf') do
  it { should be_symlink }
end
