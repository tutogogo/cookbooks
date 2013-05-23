package "nagios" do
    action :install
end

package "nagios-plugins-all" do
    action :install
end



service "nagios" do
  action [ :enable, :start ]
end


execute "create_admin_pwd" do
  command "htpasswd -b -c /etc/nagios/passwd #{node[:my-opsworks][:nagios_admin_user]} #{node[:my-opsworks][:nagios_admin_pwd]}"
end


template "/etc/nagios/cgi.cfg" do
  source "cgi.cfg.erb"
  owner "root"
  group "root"
  mode "0664"
  variables(
    :admin_user => (node[:my-opsworks][:nagios_admin_user])
  )
end


