#
# Cookbook Name:: openstack_model_t
# Recipe:: apache
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


%w{apache2 libapache2-mod-wsgi memcached python-memcache}.each do |pkg|
  package pkg do
    action [:install]
  end
end
