cookbook_file "/home/ec2-user/.aws-secrets" do
  source "aws-secrets"
  owner "root"
  group "root"
  mode "0600"
  action :create
  not_if {File.exist?("/home/ec2-user/.aws-secrets")}
end

cookbook_file "/home/ec2-user/dnscurl.pl" do
  source "dnscurl.pl"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end


cookbook_file "/home/ec2-user/MyChangeRecordsRequest.xml" do
  source "MyChangeRecordsRequest.xml"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end

cookbook_file "/home/ec2-user/update_dns.sh" do
  source "update_dns.sh"
  owner "ec2-user"
  group "ec2-user"
  mode "0755"
  action :create
end

execute "update_dns_ip" do
 command "/home/ec2-user/update_dns.sh"
end

