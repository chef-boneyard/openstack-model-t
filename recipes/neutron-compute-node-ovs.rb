#
# Cookbook Name:: openstack_model_t
# Recipe:: neutron-compute-node
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'sysctl::default'

sysctl_param 'net.ipv4.conf.all.rp_filter' do
  value 0
end

sysctl_param 'net.ipv4.conf.default.rp_filter' do
  value 0
end

sysctl_param 'net.bridge.bridge-nf-call-iptables' do
  value 1
end

sysctl_param 'net.bridge.bridge-nf-call-ip6tables' do
  value 1
end

bash "sysctl check" do
  user "root"
  cwd "/tmp"
  creates "maybe"
  code <<-EOH
    STATUS=0
    sysctl -p || STATUS=1
    exit $STATUS
  EOH
end

%w{neutron-plugin-ml2 neutron-plugin-openvswitch-agent}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/neutron/neutron.conf" do
  source "neutron-compute-node.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/plugins/ml2/ml2_conf.ini" do
  source "ml2_conf-compute-node.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

service 'openvswitch-switch' do
  supports :restart => true, :reload => true
  action :restart
end

template "/etc/nova/nova.conf" do
  source "nova-compute-node.conf.erb"
  owner "nova"
  group "nova"
  mode "0644"
end

service 'nova-compute' do
  supports :restart => true, :reload => true
  action :restart
end

service 'neutron-plugin-openvswitch-agent' do
  supports :restart => true, :reload => true
  action :restart
end
