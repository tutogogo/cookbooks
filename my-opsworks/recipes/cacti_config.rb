execute "init_inventaire_instances" do
   command ">/tmp/inventaire_instances_cacti"
end

['php-app','db-master','admin'].each do |layer|

 node[:opsworks][:layers]["#{layer}"][:instances].each do |instance, names|

  execute "add_node_cacti" do
	 command "/home/ec2-user/scripts/add_node_cacti.sh #{instance} 2>/dev/null"
  end
 
  execute "create_inventaire_instances" do
	 command "echo #{instance} >> /tmp/inventaire_instances_cacti"
  end
 end
 
end

# Purge instances obsoletes
bash "clean_obsolete_instance" do
  user "root"
  code <<-EOH
  LST_SVR=$(/usr/bin/php /var/lib/cacti/cli/remove_device.php --list-devices 2>/dev/null | awk '{ print $1 }' | tail -n+2)
  echo "List servers in cacti => $LST_SVR"
	for i in $LST_SVR
	do
		EX=$(grep $i /tmp/inventaire_instances_cacti)
		if [[ ! -n $EX ]]
		then 
		     echo "Remove $i"
		     NODE_ID=`/usr/bin/php /var/lib/cacti/cli/remove_device.php  --list-devices | grep $i | awk '{ print $1 }'`
			/usr/bin/php /var/lib/cacti/cli/remove_device.php  --device-id=$NODE_ID			
		fi
	done
	rm -f /tmp/inventaire_instances_cacti
  EOH
end

