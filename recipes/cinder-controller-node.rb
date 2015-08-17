#
# Cookbook Name:: openstack_model_t
# Recipe:: cinder-controller
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the cinder database" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/cinder-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database cinder;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['CINDER_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:CINDER_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/cinder-dbcreated
    exit $STATUS
  EOH
end

bash "create cinder user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-cinder-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:CINDER_PASS]} cinder || STATUS=1
    openstack role add --project service --user cinder admin || STATUS=1
    touch /root/model-t-setup/created-cinder-user || STATUS=1
    exit $STATUS
  EOH
end

bash "create cinder service and api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-cinder-service-and-api"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name cinder --description "OpenStack Block Storage" volume
    openstack service create --name cinder --description "OpenStack Block Storage" volumev2
    openstack endpoint create --publicurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --internalurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --adminurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --region RegionOne volume
    openstack endpoint create --publicurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --internalurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --adminurl http://#{node[:openstack_model_t][:management_network_ip]}:8776/v2/%\\(tenant_id\\)s --region RegionOne volumev2
    touch /root/model-t-setup/created-cinder-service-and-api
    exit $STATUS
  EOH
end

%w{cinder-api cinder-scheduler python-cinderclient}.each do |pkg|
  package pkg do
    action [:install]
  end
end

%w[ /var/lib/cinder ].each do |path|
  directory path do
    owner 'cinder'
    group 'cinder'
    mode '0755'
  end
end

template "/etc/cinder/cinder.conf" do
  source "cinder-controller.conf.erb"
  owner "cinder"
  group "cinder"
  mode "0644"
  notifies :restart, 'service[cinder-scheduler]', :delayed
  notifies :restart, 'service[cinder-api]', :delayed
end

bash "run cinder-mange db_sync" do
  user "cinder"
  cwd "/tmp"
  creates "/tmp/.ran-cinder-mange-dbsync"
  code <<-EOH
    STATUS=0
    cinder-manage db sync || STATUS=1
    touch /tmp/.ran-cinder-mange-dbsync
    exit $STATUS
  EOH
end

service 'cinder-scheduler' do
  supports :restart => true, :reload => true
  action :enable
end

service 'cinder-api' do
  supports :restart => true, :reload => true
  action :enable
end

file '/var/lib/cinder/cinder.sqlite' do
  action :delete
end
