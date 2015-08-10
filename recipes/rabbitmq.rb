#
# Cookbook Name:: openstack_model_t
# Recipe:: rabbitmq
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "rabbitmq-server" do
  action :install
end

bash "Create OpenStack RabbitMQ user" do
  user "root"
  cwd "/tmp"
  creates "/etc/rabbitmq/.rabbitmq-prep"
  code <<-EOH
    STATUS=0
    rabbitmqctl add_user openstack #{node['openstack_model_t']['RABBIT_PASS']} || STATUS=1
    rabbitmqctl set_permissions openstack ".*" ".*" ".*"  || STATUS=1
    touch /etc/rabbitmq/.rabbitmq-prep || STATUS=1
    exit $STATUS
  EOH
end
