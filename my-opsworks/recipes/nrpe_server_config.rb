admin_node = node[:opsworks][:layers]['admin'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil

unless admin_node.nil?

template "/etc/nagios/nrpe.cfg" do
  source "nrpe.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :admin_host => admin_node
  )

end


service "nrpe" do
  action :restart
end

end