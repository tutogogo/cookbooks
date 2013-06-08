directory "/var/lib/dolibarr" do
  owner "apache"
  group "apache"
  mode 0777
  action :create
  not_if { ::File.directory?("/var/lib/dolibarr") }
end

directory "/var/lib/dolibarr/documents" do
  owner "apache"
  group "apache"
  mode 0777
  action :create
  not_if { ::File.directory?("/var/lib/dolibarr/documents") }
end


db_node = node[:opsworks][:layers]['database'][:instances].collect{|instance, names| names["private_ip"]}.first rescue nil

unless db_node.nil?

mount "/var/lib/dolibarr/documents" do
    device "#{db_node}:/vol/mysql/documents"
    fstype "nfs"
    options "rw"
    action :mount
end

end