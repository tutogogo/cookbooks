include_recipe "mysql::ruby"
include_recipe "mysql::client"
include_recipe "mysql::server"


mysql_database node[:'my-opsworks'][:'cacti_database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node[:'my-opsworks'][:'cacti_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node[:'my-opsworks'][:'cacti_password']
  host 'localhost'
  database_name node[:'my-opsworks'][:'cacti_database']
  privileges [:all]
  action :grant
end

package "cacti" do
 action :install
end


execute "load_basic_data" do
 command "mysql -uroot -p#{node['mysql']['server_root_password']} #{node[:'my-opsworks'][:'cacti_database']} < /usr/share/doc/cacti-0.8.8a/cacti.sql"
 only_if {File.exist?("/usr/share/doc/cacti-0.8.8a/cacti.sql")}
end

execute "remove_cacti_sql" do
  command "rm -f /usr/share/doc/cacti-0.8.8a/cacti.sql"
 only_if {File.exist?("/usr/share/doc/cacti-0.8.8a/cacti.sql")}
end

template "/etc/cacti/db.php" do
  source "cacti_db.php.erb"
  owner "cacti"
  group "apache"
  mode "0640"
  variables(
    :database => node[:'my-opsworks'][:'cacti_database'],
	:db_user => node[:'my-opsworks'][:'cacti_username'],
	:db_pwd => node[:'my-opsworks'][:'cacti_password']
  )
end

cookbook_file "/home/ec2-user/cacti_cron" do
  source "cacti_cron"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "activate_crontab" do
  command "crontab -u cacti /home/ec2-user/cacti_cron"
end

cookbook_file "/etc/httpd/conf.d/cacti.conf" do
  source "cacti.conf"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

cookbook_file "/var/lib/cacti/cli/remove_device.php" do
  source "remove_device.php"
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if {File.exist?("/var/lib/cacti/cli/remove_device.php")}
end

cookbook_file "/home/ec2-user/scripts/add_cacti_template.sh" do
  source "add_cacti_template.sh"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end

cookbook_file "/tmp/Cacti_Net-SNMP_DevIO_v3.1.zip" do
  source "Cacti_Net-SNMP_DevIO_v3.1.zip"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "create_cacti_template" do
  command "/home/ec2-user/scripts/add_cacti_template.sh"
end

service "httpd" do
  action :restart
end