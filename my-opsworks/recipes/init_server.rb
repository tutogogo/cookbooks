# Create swap
#
bash "create_swap" do
  user "root"
  code <<-EOH
  if [[ ! -e /swapfile ]]
  then
  /bin/dd if=/dev/zero of=/swapfile bs=1M count=1024
  /sbin/mkswap /swapfile
  fi
  EOH
end


mount "/dev/null" do
 pass 0
 device "/swapfile"
 fstype "swap"
 action :enable
end

execute "activate_swap" do
        command "swapon -a"
end

# Define timezone Paris

execute "set_timezone_Paris" do
  command "ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime"
  action :run
end

