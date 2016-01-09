#
# Cookbook Name:: openstack_model_t
# Recipe:: neutron
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the neutron database" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/neutron-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database neutron;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['NEUTRON_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:NEUTRON_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/neutron-dbcreated
    exit $STATUS
  EOH
end

bash "create neutron user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-neutron-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:NEUTRON_PASS]} neutron || STATUS=1
    openstack role add --project service --user neutron admin || STATUS=1
    touch /root/model-t-setup/created-neutron-user || STATUS=1
    exit $STATUS
  EOH
end

bash "create neutron service and api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-neutron-service-and-api"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name neutron --description "OpenStack Networking service" network || STATUS=1
    openstack endpoint create --region RegionOne network --publicurl http://#{node[:openstack_model_t][:controller_ip]}:9696 --internalurl http://#{node[:openstack_model_t][:controller_ip]}:9696 --adminurl http://#{node[:openstack_model_t][:controller_ip]}:9696 || STATUS=1
    touch /root/model-t-setup/created-neutron-service-and-api || STATUS=1
    exit $STATUS
  EOH
end

%w{neutron-server neutron-plugin-ml2 neutron-plugin-linuxbridge-agent neutron-dhcp-agent neutron-metadata-agent python-neutronclient python-mysqldb}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/neutron/neutron.conf" do
  source "neutron-controller.conf.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/plugins/ml2/ml2_conf.ini" do
  source "ml2_conf-controller-node.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

bash "run neutron-mange db sync" do
  user "root"
  cwd "/tmp"
  creates "/root/model-t-setup/created-neutron-dbs"
  notifies :restart, 'service[nova-api]', :immediately
  notifies :restart, 'service[neutron-server]', :immediately
  code <<-EOH
    STATUS=0
    /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron || STATUS=1
    touch /root/model-t-setup/created-neutron-dbs
    exit $STATUS
  EOH
end

service 'neutron-server' do
  supports :restart => true, :reload => true
  action :enable
end
