#
# Cookbook Name:: openstack_model_t
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'python'

package "chrony" do
  action :install
end

template "/etc/chrony/chrony.conf" do
  source "chrony_compute.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[chrony]', :immediately
end

service "chrony" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end

package "nbd-client" do
  action :install
end

bash "update apt and some other cleanup repos because i want to make sure we don't bomb out" do
  user "root"
  cwd "/tmp"
  creates "maybe"
  code <<-EOH
    STATUS=0
    apt-get install -y software-properties-common || STATUS=1
    add-apt-repository cloud-archive:#{node[:openstack_model_t][:release]} || STATUS=1
    apt-get update || STATUS=1
    echo "127.0.0.1			#{node[:hostname]}" >> /etc/hosts || STATUS=1
    modprobe nbd || STATUS=1
    exit $STATUS
  EOH
end

package "python-openstackclient" do
  action :install
end

template "/root/admin-openrc.sh" do
  source "admin-openrc.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/root/demo-openrc.sh" do
  source "demo-openrc.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

include_recipe 'openstack-model-t::nova-compute-node'
include_recipe 'openstack-model-t::neutron-compute-node'
