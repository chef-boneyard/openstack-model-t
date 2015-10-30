#
# Cookbook Name:: openstack_model_t
# Recipe:: rabbitmq
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'rabbitmq::default'

template "/etc/rabbitmq/rabbitmq.conf" do
  source "rabbitmq.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[rabbitmq-server]', :immediately
end

bash "Create OpenStack RabbitMQ user" do
  user "root"
  cwd "/tmp"
  creates "/etc/rabbitmq/.rabbitmq-prep1"
  code <<-EOH
     STATUS=0
     rabbitmqctl add_user openstack #{node['openstack_model_t']['RABBIT_PASS']} || STATUS=1
     rabbitmqctl set_permissions openstack ".*" ".*" ".*"  || STATUS=1
     touch /etc/rabbitmq/.rabbitmq-prep1 || STATUS=1
     exit $STATUS
   EOH
end

bash "Give the openstack user administrator to rabbitmq" do
  user "root"
  cwd "/tmp"
  creates "/etc/rabbitmq/.rabbitmq-prep2"
  code <<-EOH
     STATUS=0
     rabbitmqctl set_user_tags openstack administrator
     touch /etc/rabbitmq/.rabbitmq-prep2 || STATUS=1
     exit $STATUS
   EOH
end

service "rabbitmq-server" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end
