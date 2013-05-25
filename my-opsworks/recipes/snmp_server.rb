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
