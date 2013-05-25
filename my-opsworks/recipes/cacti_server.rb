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

file "/home/ec2-user/cacti_cron" do
  content "*/5 * * * *  /usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&1"
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

directory "/home/ec2-user/scripts" do
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
  not_if { ::File.directory?("/home/ec2-user/scripts") }
end

cookbook_file "/home/ec2-user/scripts/add_node_cacti.sh" do
  source "add_node_cacti.sh"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end

cookbook_file "/var/lib/cacti/cli/remove_device.php" do
  source "remove_device.php"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

service "httpd" do
  action :restart
end