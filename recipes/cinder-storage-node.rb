#
# Cookbook Name:: openstack_model_t
# Recipe:: cinder-storage
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

%w{qemu lvm2}.each do |pkg|
  package pkg do
    action [:install]
  end
end

bash "create lvm2" do
  user "root"
  cwd "/tmp"
  creates "/tmp/.ran-lvm2"
  code <<-EOH
    STATUS=0
    pvcreate #{node[:openstack_model_t][:lvm_physical_volume]} || STATUS=1
    vgcreate cinder-volumes #{node[:openstack_model_t][:lvm_physical_volume]} || STATUS=1
    touch /tmp/.ran-lvm2
    exit $STATUS
  EOH
end

template "/etc/lvm/lvm.conf" do
  source "lvm.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

%w{cinder-volume python-mysqldb}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/cinder/cinder.conf" do
  source "cinder-storage.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[cinder-volume]', :delayed
  notifies :restart, 'service[tgt]', :delayed
end

service 'tgt' do
  supports :restart => true, :reload => true
  action :enable
end

service 'cinder-volume' do
  supports :restart => true, :reload => true
  action :enable
end

file '/var/lib/cinder/cinder.sqlite' do
  action :delete
end
