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
  source "chrony_controller.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[chrony]', :immediately
end

service "chrony" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end

bash "update apt repos because i want to make sure we don't bomb out" do
  user "root"
  cwd "/tmp"
  creates "maybe"
  code <<-EOH
    STATUS=0
    apt-get install -y software-properties-common || STATUS=1
    add-apt-repository cloud-archive:#{node[:openstack_model_t][:release]} || STATUS=1
    apt-get update || STATUS=1
    echo "127.0.0.1			#{node[:openstack_model_t][:controller_servername]}" >> /etc/hosts || STATUS=1
    exit $STATUS
  EOH
end

package "python-openstackclient" do
  action :install
end

template "/root/passwords2dostuff" do
  source "passwords2dostuff.erb"
  owner "root"
  group "root"
  mode "0644"
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

directory "/root/model-t-setup" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

case node[:openstack_model_t][:code]
when 'source'
  %w{git}.each do |pkg|
    package pkg do
      action [:install]
    end
  end

end

include_recipe 'openstack-model-t::mysql'
include_recipe 'openstack-model-t::mongodb'
include_recipe 'openstack-model-t::rabbitmq'
include_recipe 'openstack-model-t::keystone'
include_recipe 'openstack-model-t::glance'
include_recipe 'openstack-model-t::nova-controller-and-compute-node'
include_recipe 'openstack-model-t::neutron-controller-node'
include_recipe 'openstack-model-t::neutron-network-node'
include_recipe 'openstack-model-t::horizon'
include_recipe 'openstack-model-t::heat'
include_recipe 'openstack-model-t::cinder-controller-node'

template "/root/build_neutron_networks.sh" do
  source "build_neutron_networks.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end
