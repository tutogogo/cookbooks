package "s3cmd" do
    action :install
end

cookbook_file "/root/.s3cfg" do
  source "s3cfg"
  owner "root"
  group "root"
  mode "0600"
  action :create
  not_if {File.exist?("/root/.s3cfg")}
end

directory "/home/ec2-user/scripts" do
  owner "ec2-user"
  group "ec2-user"
  mode 0755
  action :create
  not_if { ::File.exists?("/home/ec2-user/scripts") }
end

cookbook_file "/home/ec2-user/scripts/backup-mysql-into-s3.sh" do
  source "backup-mysql-into-s3.sh"
  owner "ec2-user"
  group "ec2-user"
  mode "0655"
  action :create
end

execute "s3cmd ls" do
   command "s3cmd ls"
end
