require 'spec_helper'

describe 'openstack-model-t::default' do

  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  # File stuff

  describe file('/etc/keystone/keystone.conf') do
    it { should exist }
  end

  describe file('/etc/glance/glance-api.conf') do
    its(:content) { should match /flavor=keystone/ }
    it { should exist }
  end

  describe file('/etc/glance/glance-registry.conf') do
    its(:content) { should match /flavor=keystone/ }
    it { should exist }
  end

  describe file('/etc/apache2/apache2.conf') do
    its(:content) { should match /ServerName/ }
    it { should exist }
  end

  describe file('/etc/nova/nova.conf') do
    its(:content) { should match /rabbit_userid = openstack/ }
    it { should exist }
  end

  describe file('/etc/nova/nova-compute.conf') do
    its(:content) { should match /virt_type=qemu/ }
    it { should exist }
  end

  describe file('/etc/apache2/sites-available/wsgi-keystone.conf') do
    it { should exist }
  end

  describe file('/etc/apache2/sites-enabled/wsgi-keystone.conf') do
    it { should be_symlink }
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

  describe file('/etc/openstack-dashboard/local_settings.py') do
    it { should exist }
  end

  describe file('/etc/cinder/cinder.conf') do
    its(:content) { should match /mysql:\/\/cinder:/ }
    it { should exist }
  end

  describe file('/etc/heat/heat.conf') do
    its(:content) { should match /mysql:\/\/heat:/ }
    it { should exist }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe port(5000) do
    it { should be_listening }
  end

  describe port(8000) do
    it { should be_listening }
  end

  describe port(8004) do
    it { should be_listening }
  end

  describe port(8773) do
    it { should be_listening }
  end

  describe port(8774) do
    it { should be_listening }
  end

  describe port(8775) do
    it { should be_listening }
  end

  describe port(8776) do
    it { should be_listening }
  end

  describe port(9191) do
    it { should be_listening }
  end

  describe port(9292) do
    it { should be_listening }
  end

  describe port(35357) do
    it { should be_listening }
  end

  describe port(11211) do
    it { should be_listening }
  end

  # Processes

  describe process("memcached") do
    its(:user) { should eq "memcache" }
    it { should be_running }
  end

  describe process("mysqld") do
    its(:user) { should eq "mysql" }
    it { should be_running }
  end

  describe process("rabbitmq-server") do
    its(:user) { should eq "rabbitmq" }
    it { should be_running }
  end

  describe process("apache2") do
    its(:user) { should eq "root" }
    it { should be_running }
  end

  describe process("nova-api") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-cert") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-conductor") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-consoleauth") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-compute") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-consoleauth") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-novncproxy") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("nova-scheduler") do
    its(:user) { should eq "nova" }
    it { should be_running }
  end

  describe process("neutron-l3-agent") do
    its(:user) { should eq "neutron" }
    it { should be_running }
  end

  describe process("neutron-dhcp-agent") do
    its(:user) { should eq "neutron" }
    it { should be_running }
  end

  describe process("neutron-metadata-agent") do
    its(:user) { should eq "neutron" }
    it { should be_running }
  end

  describe process("neutron-linuxbridge-agent") do
    its(:user) { should eq "neutron" }
    it { should be_running }
  end

end
