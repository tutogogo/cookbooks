package "httpd" do
    action :install
end

package "php" do
    action :install
end

service "httpd" do
  action [ :enable, :start ]
end
