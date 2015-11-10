#
# Cookbook Name:: openstack-model-t
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'openstack-model-t::default' do

  context 'When all attributes are default, and we are confirming the tests can run' do

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

  end

  context 'When all attributes are default, on an unspecified platform' do

    let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) do
      runner.converge(described_recipe)
    end

    let(:file_cache_path) { Chef::Config[:file_cache_path] }

    it 'creates a directory /root/model-t-setup' do
      expect(chef_run).to create_directory('/root/model-t-setup')
    end

    it 'creates a directory /etc/keystone' do
      expect(chef_run).to create_directory('/etc/keystone')
    end

    it 'creates a directory /var/www/cgi-bin' do
      expect(chef_run).to create_directory('/var/www/cgi-bin')
    end

    it 'creates a directory /var/www/cgi-bin/keystone' do
      expect(chef_run).to create_directory('/var/www/cgi-bin/keystone')
    end

    it 'creates a directory /var/lib/glance' do
      expect(chef_run).to create_directory('/var/lib/glance')
    end

    it 'creates a directory /var/lib/glance/images' do
      expect(chef_run).to create_directory('/var/lib/glance/images')
    end

    it 'creates a directory /var/lib/cinder' do
      expect(chef_run).to create_directory('/var/lib/cinder')
    end

    it 'should install ntp' do
      expect(chef_run).to install_package('ntp')
    end

    it 'should install mariadb-server' do
      expect(chef_run).to install_package('mariadb-server')
    end

    it 'should install python-mysqldb' do
      expect(chef_run).to install_package('python-mysqldb')
    end

    it 'should install keystone' do
      expect(chef_run).to install_package('keystone')
    end

    it 'should install python-openstackclient' do
      expect(chef_run).to install_package('python-openstackclient')
    end

    it 'should install apache2' do
      expect(chef_run).to install_package('apache2')
    end

    it 'should install libapache2-mod-wsgi' do
      expect(chef_run).to install_package('libapache2-mod-wsgi')
    end

    it 'should install memcached' do
      expect(chef_run).to install_package('memcached')
    end

    it 'should install python-memcache' do
      expect(chef_run).to install_package('python-memcache')
    end

    it 'should install glance' do
      expect(chef_run).to install_package('glance')
    end

    it 'should install python-glanceclient' do
      expect(chef_run).to install_package('python-glanceclient')
    end

    it 'should install nova-api' do
      expect(chef_run).to install_package('nova-api')
    end

    it 'should install nova-cert' do
      expect(chef_run).to install_package('nova-cert')
    end

    it 'should install nova-conductor' do
      expect(chef_run).to install_package('nova-conductor')
    end

    it 'should install nova-consoleauth' do
      expect(chef_run).to install_package('nova-consoleauth')
    end

    it 'should install nova-novncproxy' do
      expect(chef_run).to install_package('nova-novncproxy')
    end

    it 'should install python-novaclient' do
      expect(chef_run).to install_package('python-novaclient')
    end

    it 'should install nova-compute' do
      expect(chef_run).to install_package('nova-compute')
    end

    it 'should install sysfsutils' do
      expect(chef_run).to install_package('sysfsutils')
    end

    it 'should install neutron-server' do
      expect(chef_run).to install_package('neutron-server')
    end

    it 'should install neutron-plugin-ml2' do
      expect(chef_run).to install_package('neutron-plugin-ml2')
    end

    it 'should install python-neutronclient' do
      expect(chef_run).to install_package('python-neutronclient')
    end

    it 'should install neutron-plugin-linuxbridge-agent ' do
      expect(chef_run).to install_package('neutron-plugin-linuxbridge-agent')
    end

    it 'should install neutron-l3-agent ' do
      expect(chef_run).to install_package('neutron-l3-agent')
    end

    it 'should install neutron-dhcp-agent ' do
      expect(chef_run).to install_package('neutron-dhcp-agent')
    end

    it 'should install neutron-metadata-agent ' do
      expect(chef_run).to install_package('neutron-metadata-agent')
    end

    it 'should install openstack-dashboard ' do
      expect(chef_run).to install_package('openstack-dashboard')
    end

    it 'should install openstack-dashboard-ubuntu-theme ' do
      expect(chef_run).not_to install_package('openstack-dashboard-ubuntu-theme')
    end

    describe 'keep the ubuntu-dashboard' do
      let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
      let(:node) { runner.node }
      let(:chef_run) do
        node.set['openstack_model_t']['ubuntu_themeing'] = true
        runner.converge(described_recipe)
      end

      it 'should install openstack-dashboard ' do
        expect(chef_run).to install_apt_package('openstack-dashboard-ubuntu-theme')
      end

    end

    it 'should install heat-api ' do
      expect(chef_run).to install_package('heat-api')
    end

    it 'should install heat-api-cfn ' do
      expect(chef_run).to install_package('heat-api-cfn')
    end

    it 'should install heat-engine ' do
      expect(chef_run).to install_package('heat-engine')
    end

    it 'should install python-heatclient ' do
      expect(chef_run).to install_package('python-heatclient')
    end

    it 'should install cinder-api ' do
      expect(chef_run).to install_package('cinder-api')
    end

    it 'should install cinder-scheduler ' do
      expect(chef_run).to install_package('cinder-scheduler')
    end

    it 'should install python-cinderclient ' do
      expect(chef_run).to install_package('python-cinderclient')
    end

    it 'should create /root/passwords2dostuff ' do
      expect(chef_run).to create_template('/root/passwords2dostuff')
    end

    it 'should create /root/admin-openrc.sh ' do
      expect(chef_run).to create_template('/root/admin-openrc.sh')
    end

    it 'should create /root/demo-openrc.sh ' do
      expect(chef_run).to create_template('/root/demo-openrc.sh')
    end

    it 'should create /etc/mysql/my.cnf ' do
      expect(chef_run).to create_template('/etc/mysql/my.cnf')
    end

    it 'should create /etc/mysql/conf.d/mysql_openstack.cnf' do
      expect(chef_run).to create_template('/etc/mysql/conf.d/mysql_openstack.cnf')
    end

    it 'should create /etc/rabbitmq/rabbitmq.conf' do
      expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.conf')
    end

    it 'should create /etc/keystone/keystone.conf' do
      expect(chef_run).to create_template('/etc/keystone/keystone.conf')
    end

    it 'should create /etc/apache2/sites-available/wsgi-keystone.conf' do
      expect(chef_run).to create_template('/etc/apache2/sites-available/wsgi-keystone.conf')
    end

    it 'should create /etc/apache2/apache2.conf' do
      expect(chef_run).to create_template('/etc/apache2/apache2.conf')
    end

    it 'should create /etc/glance/glance-api.conf' do
      expect(chef_run).to create_template('/etc/glance/glance-api.conf')
    end

    it 'should create /etc/glance/glance-registry.conf' do
      expect(chef_run).to create_template('/etc/glance/glance-registry.conf')
    end

    it 'should create /etc/nova/nova.conf' do
      expect(chef_run).to create_template('/etc/nova/nova.conf')
    end

    it 'should create /etc/nova/nova-compute.conf' do
      expect(chef_run).to create_template('/etc/nova/nova-compute.conf')
    end

    it 'should create /etc/neutron/neutron.conf' do
      expect(chef_run).to create_template('/etc/neutron/neutron.conf')
    end

    it 'should create /etc/neutron/plugins/ml2/ml2_conf.ini' do
      expect(chef_run).to create_template('/etc/neutron/plugins/ml2/ml2_conf.ini')
    end

    it 'should create /etc/neutron/l3_agent.ini' do
      expect(chef_run).to create_template('/etc/neutron/l3_agent.ini')
    end

    it 'should create /etc/neutron/dhcp_agent.ini' do
      expect(chef_run).to create_template('/etc/neutron/dhcp_agent.ini')
    end

    it 'should create /etc/neutron/metadata_agent.ini' do
      expect(chef_run).to create_template('/etc/neutron/metadata_agent.ini')
    end

    it 'should create /etc/neutron/dnsmasq-neutron.conf' do
      expect(chef_run).to create_template('/etc/neutron/dnsmasq-neutron.conf')
    end

    it 'should create /etc/openstack-dashboard/local_settings.py' do
      expect(chef_run).to create_template('/etc/openstack-dashboard/local_settings.py')
    end

    it 'should create /etc/heat/heat.conf' do
      expect(chef_run).to create_template('/etc/heat/heat.conf')
    end

    it 'should create /etc/cinder/cinder.conf' do
      expect(chef_run).to create_template('/etc/cinder/cinder.conf')
    end

    it 'should create /root/build_neutron_networks.sh' do
      expect(chef_run).to create_template('/root/build_neutron_networks.sh')
    end

    it 'starts a mysql service' do
      expect(chef_run).to start_service('mysql')
    end

    it 'starts a rabbitmq service' do
      expect(chef_run).to start_service('rabbitmq-server')
    end

    it 'starts a apache2 service' do
      expect(chef_run).to start_service('apache2')
    end

    it 'starts a glance-registry service' do
      expect(chef_run).to start_service('glance-registry')
    end

    it 'starts a glance-api service' do
      expect(chef_run).to start_service('glance-api')
    end

    it 'starts a nova-api service' do
      expect(chef_run).to start_service('nova-api')
    end

    it 'starts a nova-cert service' do
      expect(chef_run).to start_service('nova-cert')
    end

    it 'starts a nova-consoleauth service' do
      expect(chef_run).to start_service('nova-consoleauth')
    end

    it 'starts a nova-scheduler service' do
      expect(chef_run).to start_service('nova-scheduler')
    end

    it 'starts a nova-conductor service' do
      expect(chef_run).to start_service('nova-conductor')
    end

    it 'starts a nova-novncproxy service' do
      expect(chef_run).to start_service('nova-novncproxy')
    end

    it 'starts a nova-compute service' do
      expect(chef_run).to start_service('nova-compute')
    end

  end
end
