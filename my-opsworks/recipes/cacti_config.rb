node[:opsworks][:layers]["php-app"][:instances].each do |instance, names|
 execute "add_node_cacti" do
	command "/home/ec2-user/scripts/add_node_cacti.sh #{instance}"
 end
end

node[:opsworks][:layers]["db-master"][:instances].each do |instance, names|
 execute "add_node_cacti" do
	command "/home/ec2-user/scripts/add_node_cacti.sh #{instance}"
 end
end