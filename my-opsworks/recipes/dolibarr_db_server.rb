include_recipe "mysql::ruby"
include_recipe "mysql::client"
include_recipe "mysql::server"


mysql_database node[:'my-opsworks'][:'dolibarr_database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node[:'my-opsworks'][:'dolibarr_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node[:'my-opsworks'][:'dolibarr_password']
  host '%'
  database_name node[:'my-opsworks'][:'dolibarr_database']
  privileges [:all]
  action :grant
end
