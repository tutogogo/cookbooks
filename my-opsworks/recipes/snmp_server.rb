package "snmp" do
  action :install
end

service "snmp" do
  action [ :enable, :start ]
end

directory "/home/ec2-user/scripts" do
  owner "ec2-user"
  group "ec2-user"
  mode 0755
  action :create
  not_if { ::File.directory?("/home/ec2-user/scripts") }
end

cookbook_file "/home/ec2-user/" do
  source "cacti.conf"
  owner "root"
  group "root"
  mode "0644"
  action :create
end