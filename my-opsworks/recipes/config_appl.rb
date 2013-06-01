node[:deploy].each do |app_name, deploy|
directory "/var/lib/dolibarr" do
  owner "apache"
  group "apache"
  mode 0777
  action :create
  not_if { ::File.directory?("/var/lib/dolibarr") }
end

directory "/var/lib/dolibarr/documents" do
  owner "apache"
  group "apache"
  mode 0777
  action :create
  not_if { ::File.directory?("/var/lib/dolibarr/documents") }
end


db_node = node[:opsworks][:layers]['database'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil

unless db_node.nil?

mount "/var/lib/dolibarr/documents" do
    device "#{db_node}:/vol/mysql/documents"
    fstype "nfs"
    options "rw"
    action :mount
end


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
