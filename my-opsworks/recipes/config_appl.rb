node[:deploy].each do |app_name, deploy|

db_node = node[:opsworks][:layers]['database'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil

unless db_node.nil?


template "#{deploy[:deploy_to]}/current/htdocs/conf/conf.php" do
  source "conf.php.erb"
  owner "apache"
  group "apache"
  mode "0644"
  variables(
    :dbhost => db_node,
    :dbname => node[:'my-opsworks'][:'dolibarr_database'],
    :dbuser => node[:'my-opsworks'][:'dolibarr_username'],
    :dbpwd => node[:'my-opsworks'][:'dolibarr_password']
  )
only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
end

end

end
