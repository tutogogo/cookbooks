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

