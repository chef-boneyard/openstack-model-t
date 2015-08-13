#
# Cookbook Name:: openstack_model_t
# Recipe:: keystone
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

bash "create the keystone database" do
  user "root"
  cwd "/tmp"
  creates "/root/model-t-setup/keystone-dbcreated"
  code <<-EOH
    STATUS=0
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "create database keystone;"
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '#{node[:openstack_model_t]['KEYSTONE_DBPASS']}';" || STATUS=1
     mysql  -u root -p#{node[:openstack_model_t][:mariadb_pass]} -e "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '#{node[:openstack_model_t][:KEYSTONE_DBPASS]}';" || STATUS=1
    touch /root/model-t-setup/keystone-dbcreated
    exit $STATUS
  EOH
end

bash "disable keystone service from starting after installation" do
  user "root"
  cwd "/tmp"
  creates "/etc/init/keystone.override"
  code <<-EOH
    STATUS=0
    echo "manual" > /etc/init/keystone.override || STATUS=1
    exit $STATUS
  EOH
end

%w{keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache}.each do |pkg|
  package pkg do
    action [:install]
  end
end

directory "/etc/keystone" do
  owner "keystone"
  group "keystone"
  mode "0755"
  action :create
end

template "/etc/keystone/keystone.conf" do
  source "keystone.conf.erb"
  owner "keystone"
  group "keystone"
  mode "0644"
  notifies :restart, 'service[apache2]', :delayed
end

execute "make sure keystone owns it's etc directory" do
  user "root"
  command "chown -R keystone:keystone /etc/keystone"
  action :run
end

template "/etc/apache2/sites-available/wsgi-keystone.conf" do
  source "wsgi-keystone.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[apache2]', :delayed
end

template "/etc/apache2/apache2.conf" do
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[apache2]', :delayed
end

bash "run keystone-mange db_sync" do
  user "keystone"
  cwd "/tmp"
  creates "maybe"
  code <<-EOH
    STATUS=0
    keystone-manage db_sync || STATUS=1
    exit $STATUS
  EOH
end

link '/etc/apache2/sites-enabled/wsgi-keystone.conf' do
  to '/etc/apache2/sites-available/wsgi-keystone.conf'
end

%w[ /var/www/cgi-bin /var/www/cgi-bin/keystone ].each do |path|
  directory path do
    owner 'keystone'
    group 'keystone'
    mode '0755'
    notifies :restart, 'service[apache2]', :delayed
  end
end

remote_file '/var/www/cgi-bin/keystone/main' do
  source "http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/#{node[:openstack_model_t][:release]}"
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end

remote_file '/var/www/cgi-bin/keystone/admin' do
  source "http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/#{node[:openstack_model_t][:release]}"
  mode '0644'
  notifies :restart, 'service[apache2]', :delayed
end

bash "change ownership for keystone" do
  user "root"
  cwd "/tmp"
  creates "/var/www/cgi-bin/.ownership4keystone"
  notifies :restart, 'service[apache2]', :immediately
  code <<-EOH
    STATUS=0
    chown -R keystone:keystone /var/www/cgi-bin/keystone || STATUS=1
    chmod 755 /var/www/cgi-bin/keystone/* || STATUS=1
    touch /var/www/cgi-bin/.ownership4keystone
    exit $STATUS
  EOH
end

file '/var/lib/keystone/keystone.db' do
  action :delete
end

service 'apache2' do
  supports :restart => true, :reload => true
  action :enable
end

bash "create keystone service entity" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-keystone-service-entity"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack service create --name keystone --description "OpenStack Identity" identity || STATUS=1
    touch /root/model-t-setup/created-keystone-service-entity || STATUS=1
    exit $STATUS
  EOH
end

bash "create keystone api endpoint" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-keystone-api-endpoint"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack endpoint create --publicurl http://#{node[:openstack_model_t][:management_network_ip]}:5000/v2.0 --internalurl http://#{node[:openstack_model_t][:management_network_ip]}:5000/v2.0 --adminurl http://#{node[:openstack_model_t][:management_network_ip]}:35357/v2.0 --region RegionOne identity || STATUS=1
    touch /root/model-t-setup/created-keystone-api-endpoint || STATUS=1
    exit $STATUS
  EOH
end

bash "create admin project, user and role" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-admin-project-user-role"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack project create --description "Admin Project" admin || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:ADMIN_PASS]} admin || STATUS=1
    openstack role create admin || STATUS=1
    openstack role add --project admin --user admin admin || STATUS=1
    touch /root/model-t-setup/created-admin-project-user-role || STATUS=1
    exit $STATUS
  EOH
end

bash "create service and demo projects" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-service-and-demo-projects"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack project create --description "Service Project" service || STATUS=1
    openstack project create --description "Demo Project" demo || STATUS=1
    touch /root/model-t-setup/created-service-and-demo-projects || STATUS=1
    exit $STATUS
  EOH
end

bash "create demo user" do
  user "root"
  cwd "/root"
  creates "/root/model-t-setup/created-demo-user"
  code <<-EOH
    STATUS=0
    source passwords2dostuff || STATUS=1
    openstack user create --password #{node[:openstack_model_t][:DEMO_PASS]} demo || STATUS=1
    openstack role create user || STATUS=1
    openstack role add --project demo --user demo user || STATUS=1
    touch /root/model-t-setup/created-demo-user || STATUS=1
    exit $STATUS
  EOH
end

# Hopefully you've read this recipe and seen whats happened before blindly running it.
# You should bring up the following website and verify it to prove to yourself that
# keystone is setup correctly.
# Go forth and conquer!
# http://docs.openstack.org/kilo/install-guide/install/apt/content/keystone-verify.html
