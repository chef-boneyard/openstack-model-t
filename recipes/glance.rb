#
# Cookbook Name:: openstack_model_t
# Recipe:: glance
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the glance database" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/glance-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database glance;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['GLANCE_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:GLANCE_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/glance-dbcreated
    exit $STATUS
  EOH
end

bash "create glance user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-glance-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:GLANCE_PASS]} glance || STATUS=1
    openstack role add --project service --user glance admin || STATUS=1
    touch /root/model-t-setup/created-glance-user || STATUS=1
    exit $STATUS
  EOH
end

bash "create glance service and api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-glance-service-and-api"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name glance --description "OpenStack Image service" image || STATUS=1
    openstack endpoint create --region RegionOne image --publicurl  http://#{node[:openstack_model_t][:controller_ip]}:9292 --internalurl  http://#{node[:openstack_model_t][:controller_ip]}:9292 --adminurl http://#{node[:openstack_model_t][:controller_ip]}:9292
    touch /root/model-t-setup/created-glance-service-and-api || STATUS=1
    exit $STATUS
  EOH
end

%w{glance python-glanceclient}.each do |pkg|
  package pkg do
    action [:install]
  end
end

%w[ /var/lib/glance /var/lib/glance/images ].each do |path|
  directory path do
    owner 'glance'
    group 'glance'
    mode '0755'
  end
end

bash "make sure the glance directory permissions are good" do
  user "root"
  cwd "/var/lib/"
  creates "/var/lib/glance/image-cache"
  code <<-EOH
    STATUS=0
    chown -R glance.glance /var/lib/glance || STATUS=1
    exit $STATUS
  EOH
end

template "/etc/glance/glance-api.conf" do
  source "glance-api.conf.erb"
  owner "glance"
  group "glance"
  mode "0644"
  notifies :restart, 'service[glance-registry]', :delayed
  notifies :restart, 'service[glance-api]', :delayed
end

template "/etc/glance/glance-registry.conf" do
  source "glance-registry.conf.erb"
  owner "glance"
  group "glance"
  mode "0644"
  notifies :restart, 'service[glance-registry]', :delayed
  notifies :restart, 'service[glance-api]', :delayed
end

bash "run glance-mange db_sync" do
  user "glance"
  cwd "/tmp"
  creates "/tmp/.ran-glance-mange-dbsync"
  code <<-EOH
    STATUS=0
    glance-manage db_sync || STATUS=1
    touch /tmp/.ran-glance-mange-dbsync
    exit $STATUS
  EOH
end

service 'glance-registry' do
  supports :restart => true, :reload => true
  action :enable
end

service 'glance-api' do
  supports :restart => true, :reload => true
  action :enable
end

file '/var/lib/glance/glance.sqlite' do
  action :delete
end

# Congrats! You now have a working glance server/system/whatever
# You should probably verify it go to here:
# http://docs.openstack.org/liberty/install-guide-ubuntu/glance-verify.html
# or if you're lazy
#
# source admin-openrc.sh
# mkdir /tmp/images
# wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
# glance image-create --name "cirros-0.3.4-x86_64" --file /tmp/images/cirros-0.3.4-x86_64-disk.img \
#  --disk-format qcow2 --container-format bare --visibility public --progress
# glance image-list
#
