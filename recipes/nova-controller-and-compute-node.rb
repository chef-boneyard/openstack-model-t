#
# Cookbook Name:: openstack_model_t
# Recipe:: nova-controller-node
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the nova database" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/nova-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database nova;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['NOVA_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:NOVA_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/nova-dbcreated
    exit $STATUS
  EOH
end

bash "create nova user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-nova-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:NOVA_PASS]} nova || STATUS=1
    openstack role add --project service --user nova admin || STATUS=1
    touch /root/model-t-setup/created-nova-user || STATUS=1
    exit $STATUS
  EOH
end

bash "create nova service and api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-nova-service-and-api"
  notifies :restart, 'service[apache2]', :immediately
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name nova --description "OpenStack Compute service" compute || STATUS=1
    openstack endpoint create --region RegionOne compute --publicurl http://#{node[:openstack_model_t][:controller_ip]}:8774/v2/%\\(tenant_id\\)s --adminurl http://#{node[:openstack_model_t][:controller_ip]}:8774/v2/%\\(tenant_id\\)s --internalurl http://#{node[:openstack_model_t][:controller_ip]}:8774/v2/%\\(tenant_id\\)s
    touch /root/model-t-setup/created-nova-service-and-api
    exit $STATUS
  EOH
end

%w{nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy python-novaclient nova-compute sysfsutils}.each do |pkg|
  package pkg do
    action [:install]
  end
end

bash "because nova-scheduler has wierd deps" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    STATUS=0
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    locale-gen en_US.UTF-8
    apt-get install -y nova-scheduler || STATUS=1
    exit $STATUS
  EOH
end

template "/etc/nova/nova.conf" do
  source "nova-controller-and-compute.conf.erb"
  owner "nova"
  group "nova"
  mode "0644"
  notifies :restart, 'service[nova-api]', :immediately
  notifies :restart, 'service[nova-cert]', :immediately
  notifies :restart, 'service[nova-consoleauth]', :immediately
  notifies :restart, 'service[nova-scheduler]', :immediately
  notifies :restart, 'service[nova-conductor]', :immediately
  notifies :restart, 'service[nova-novncproxy]', :immediately
  notifies :restart, 'service[nova-compute]', :immediately
end

template "/etc/nova/nova-compute.conf" do
  source "nova-compute.conf.erb"
  owner "nova"
  group "nova"
  mode "0644"
  notifies :restart, 'service[nova-compute]', :delayed
end

bash "run nova-mange db sync" do
  user "nova"
  cwd "/tmp"
  creates "/tmp/ran-nova-db-sync"
  code <<-EOH
    STATUS=0
    sleep 10
    nova-manage db sync || STATUS=1
    touch /tmp/ran-nova-db-sync
    exit $STATUS
  EOH
end

service 'nova-api' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-cert' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-consoleauth' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-scheduler' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-conductor' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-novncproxy' do
  supports :restart => true, :reload => true
  action :nothing
end

service 'nova-compute' do
  supports :restart => true, :reload => true
  action :nothing
end

file '/var/lib/nova/nova.sqlite' do
  action :delete
end
