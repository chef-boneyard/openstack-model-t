#
# Cookbook Name:: openstack_model_t
# Recipe:: neutron-network-node
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'sysctl::default'

sysctl_param 'net.ipv4.ip_forward' do
  value 1
end

sysctl_param 'net.ipv4.conf.all.rp_filter' do
  value 0
end

sysctl_param 'net.ipv4.conf.default.rp_filter' do
  value 0
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

%w{neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/neutron/neutron.conf" do
  source "neutron-network.conf.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/plugins/ml2/ml2_conf.ini" do
  source "ml2_conf-network-node.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/l3_agent.ini" do
  source "l3_agent.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/dhcp_agent.ini" do
  source "dhcp_agent.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

template "/etc/neutron/dnsmasq-neutron.conf" do
  source "dnsmasq-neutron.conf.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

execute "kill those dnsmasq procs" do
  command "pkill dnsmasq && touch /root/model-t-setup/killed_dnsmasq"
  creates "/root/model-t-setup/killed_dnsmasq"
  action :run
end

template "/etc/neutron/metadata_agent.ini" do
  source "metadata_agent.ini.erb"
  owner "neutron"
  group "neutron"
  mode "0644"
end

service 'nova-api' do
  supports :restart => true, :reload => true
  action :restart
end

service 'openvswitch-switch' do
  supports :restart => true, :reload => true
  action :restart
end

bash "create ovs external bridge" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/network-node-external-ovs-bridge"
  code <<-EOH
    STATUS=0
    ovs-vsctl add-br br-ex || STATUS=1
    ovs-vsctl add-port br-ex #{node[:openstack_model_t][:network_node_external_bridge]} || STATUS=1
    touch /root/model-t-setup/network-node-external-ovs-bridge
    exit $STATUS
  EOH
end

service 'neutron-plugin-openvswitch-agent' do
  supports :restart => true, :reload => true
  action :restart
end

service 'neutron-l3-agent' do
  supports :restart => true, :reload => true
  action :restart
end

service 'neutron-dhcp-agent' do
  supports :restart => true, :reload => true
  action :restart
end

service 'neutron-metadata-agent' do
  supports :restart => true, :reload => true
  action :restart
end
