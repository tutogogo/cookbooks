execute "init_inventaire_instances" do
   command ">/tmp/inventaire_instances_nagios"
end

node[:opsworks][:layers]["php-app"][:instances].each do |instance, names|
template "/etc/nagios/remotehost/#{instance}.cfg" do
  source "web_server.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :web_host => instance
  )
end

execute "create_inventaire_instances" do
   command "echo #{instance}.cfg >> /tmp/inventaire_instances_nagios"
end

end

node[:opsworks][:layers]["db-master"][:instances].each do |instance, names|
template "/etc/nagios/remotehost/#{instance}.cfg" do
  source "db_server.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :db_host => instance
  )
end

execute "create_inventaire_instances" do
   command "echo #{instance}.cfg >> /tmp/inventaire_instances_nagios"
end

end

# Purge instances obsoletes
bash "clean_obsolete_instance" do
  user "root"
  code <<-EOH
	for i in `ls /etc/nagios/remotehost`
	do
		EX=$(grep $i /tmp/inventaire_instances_nagios)
		if [[ ! -n $EX ]]
		then
			rm -f /etc/nagios/remotehost/$i
		fi
	done
	rm -f /tmp/inventaire_instances_nagios
  EOH
end


service "nagios" do
   action :restart
   ignore_failure true
end
