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
  mode "0755"
  action :create
end

cookbook_file "/home/ec2-user/scripts/backup-doc-into-s3.sh" do
  source "backup-doc-into-s3.sh"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end


template "/home/ec2-user/ec2-user_cron" do
  source "ec2-user_cron.erb"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  variables(
    :root_pwd => node['mysql']['server_root_password']
  )
end

execute "activate_crontab" do
  command "crontab -u ec2-user /home/ec2-user/ec2-user_cron"
end

