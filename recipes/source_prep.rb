#
# Cookbook Name:: openstack_model_t
# Recipe:: source_prep
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

directory "/opt/model-t/" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

%w{build-essential wget libyaml-dev zlib1g-dev libreadline-dev libssl-dev tk-dev libgdbm-dev libffi-dev}.each do |pkg|
  package pkg do
    action [:install]
  end
end

python_pip 'oslo.config'

python_pip 'oslo.log'

python_pip 'python-openstackclient'
