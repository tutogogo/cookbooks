package "net-snmp" do
  action :install
end

template "/etc/snmp/snmpd.conf" do
  source "snmpd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :community => "dolibarr"
  )
end


service "snmpd" do
  action [ :enable, :start ]
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
  owner "cacti"
  group "cacti"
  mode "0755"
  action :create
end
