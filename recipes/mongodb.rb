#
# Cookbook Name:: openstack_model_t
# Recipe:: mongodb
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


%w{mongodb-server mongodb-clients python-pymongo}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/mongodb.conf" do
  source "mongodb.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "mongodb" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end
