package "nfs-utils" do
    action :install
end

service "rpcbind" do
  action [ :enable, :start ]
end

service "nfs" do
  action [ :enable, :start ]
end

directory "/vol/mysql/documents" do
  owner "root"
  group "root"
  mode 0777
  action :create
  not_if { ::File.exists?("/vol/mysql/documents") }
end

file "/etc/exports" do
content "/vol/mysql/documents *(rw,sync)"
mode "0644"
owner "root"
group "root"
action :create
end

execute "share_documents_fs" do

command "exportfs -ar"

end