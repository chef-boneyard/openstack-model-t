#
# Cookbook Name:: openstack_model_t
# Recipe:: horizon
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "openstack-dashboard" do
  action :install
end

template "/etc/openstack-dashboard/local_settings.py" do
  source "local_settings.py.erb"
  owner "apache"
  group "apache"
  mode "0644"
end

service "apache2" do
  action [ :reload ]
end
