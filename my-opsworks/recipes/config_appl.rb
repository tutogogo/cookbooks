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

mount "/var/lib/dolibarr/documents" do
    device "#{deploy[:database][:host]}:/vol/mysql/documents"
    fstype "nfs"
    options "rw"
    action :mount
    not_if { deploy[:database][:host].nil? }
end


template "#{deploy[:deploy_to]}/current/htdocs/conf/conf.php" do
  source "conf.php.erb"
  owner "apache"
  group "apache"
  mode "0644"
  variables(
    :dbhost => (deploy[:database][:host] rescue nil),
    :dbpwd => (deploy[:database][:password] rescue nil)
  )
only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
end

end
