#
# Cookbook Name:: openstack_model_t
# Recipe:: heat
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the heat database" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/heat-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database heat;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['HEAT_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:HEAT_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/heata-dbcreated
    exit $STATUS
  EOH
end

bash "create heat user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-heat-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:HEAT_PASS]} heat || STATUS=1
    openstack role add --project service --user heat admin || STATUS=1
    openstack role create heat_stack_owner || STATUS=1
    openstack role add --project demo --user demo heat_stack_owner || STATUS=1
    openstack role create heat_stack_user || STATUS=1
    touch /root/model-t-setup/created-heat-user || STATUS=1
    exit $STATUS
  EOH
end

bash "create heat service and api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-heat-service-and-api"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name heat --description "OpenStack Orchestration" orchestration
    openstack service create --name heat --description "OpenStack Orchestration" cloudformation
    openstack endpoint create --publicurl http://#{node[:openstack_model_t][:management_network_ip]}:8004/v1/%\\(tenant_id\\)s --internalurl http://#{node[:openstack_model_t][:management_network_ip]}:8004/v1/%\\(tenant_id\\)s --adminurl http://#{node[:openstack_model_t][:management_network_ip]}:8004/v1/%\\(tenant_id\\)s --region RegionOne orchestration
    openstack endpoint create --publicurl http://#{node[:openstack_model_t][:management_network_ip]}:8000/v1/ --internalurl http://#{node[:openstack_model_t][:management_network_ip]}:8000/v1/ --adminurl http://#{node[:openstack_model_t][:management_network_ip]}:8000/v1/ --region RegionOne cloudformation
    touch /root/model-t-setup/created-glance-service-and-api
    exit $STATUS
  EOH
end

%w{heat-api heat-api-cfn heat-engine python-heatclient}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/heat/heat.conf" do
  source "heat.conf.erb"
  owner "heat"
  group "heat"
  mode "0644"
end

bash "run heat-mange db_sync" do
  user "heat"
  cwd "/tmp"
  creates "/tmp/.ran-heat-mange-dbsync"
  code <<-EOH
    STATUS=0
    heat-manage db_sync || STATUS=1
    touch /tmp/.ran-heat-mange-dbsync
    exit $STATUS
  EOH
end

service 'heat-api' do
  supports :restart => true, :reload => true
  action :restart
end

service 'heat-api-cfn' do
  supports :restart => true, :reload => true
  action :restart
end

service 'heat-engine' do
  supports :restart => true, :reload => true
  action :restart
end

file '/var/lib/glance/glance.sqlite' do
  action :delete
end
