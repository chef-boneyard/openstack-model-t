#
# Cookbook Name:: openstack_model_t
# Recipe:: nova-compute-node
#
# Copyright (c) 2015 The Authors, All Rights


%w{nova-compute sysfsutils}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/nova/nova.conf" do
  source "nova-compute-node.conf.erb"
  owner "nova"
  group "nova"
  mode "0644"
  notifies :restart, 'service[nova-compute]', :delayed
end

template "/etc/nova/nova-compute.conf" do
  source "nova-compute.conf.erb"
  owner "nova"
  group "nova"
  mode "0644"
  notifies :restart, 'service[nova-compute]', :delayed
end

service 'nova-compute' do
  supports :restart => true, :reload => true
  action :enable
end

file '/var/lib/nova/nova.sqlite' do
  action :delete
end
