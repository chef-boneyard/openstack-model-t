#
# Cookbook Name:: openstack_model_t
# Recipe:: mysql
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


%w{mariadb-server python-pymysql}.each do |pkg|
  package pkg do
    action [:install]
  end
end

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/etc/mysql/conf.d/mysql_openstack.cnf" do
  source "mysql_openstack.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[mysql]', :immediately
end

bash "secure_mysql_instance" do
  user "root"
  cwd "/tmp"
  creates "/etc/mysql/.secure-mariadb"
  code <<-EOH
     STATUS=0
     mysql -e "DROP USER ''@'localhost'"
     mysql -e "DROP USER ''@'$(hostname)'"
     mysql -e "DROP DATABASE test"
     mysql -e "FLUSH PRIVILEGES"
     mysqladmin -u root password #{node['openstack_model_t']['mariadb_pass']}
     touch /etc/mysql/.secure-mariadb || STATUS=1
     exit $STATUS
   EOH
end

service "mysql" do
  supports :status => true, :restart => true, :truereload => true
  action [ :enable, :start ]
end
