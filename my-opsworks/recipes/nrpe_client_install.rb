package "nagios-plugins-nrpe" do
    action :install
end

service "nagios" do
    action :stop
end


template "/etc/nagios/nagios.cfg" do
  source "nagios.cfg.erb"
  owner "root"
  group "root"
  mode "0664"
end


directory "/etc/nagios/remotehost" do
  owner "root"
  group "root"
  mode 0755
  action :create
  not_if { ::File.directory?("/etc/nagios/remotehost") }
end


cookbook_file "/etc/nagios/nrpe_commands.cfg" do
  source "nrpe_commands.cfg"
  owner "root"
  group "root"
  mode 0755 
  action :create_if_missing
end


service "nagios" do
    action :start
    ignore_failure true
end