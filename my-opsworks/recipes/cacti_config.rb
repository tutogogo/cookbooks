execute "init_inventaire_instances" do
   command ">/tmp/inventaire_instances"
end

my-layers = ['php-app', 'db-master', 'admin'] 

my-layers.each do |layer|

 node[:opsworks][:layers]["#{layer}"][:instances].each do |instance, names|

  execute "add_node_cacti" do
	 command "/home/ec2-user/scripts/add_node_cacti.sh #{instance}"
  end
 
  execute "create_inventaire_instances" do
	 command "echo #{instance} >> /tmp/inventaire_instances"
  end
 end
 
end

