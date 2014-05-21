# Install and configure zookeeper

# pull cluster info from a data bag, defaulting to a single node if no data bag is available
if node[:zookeeper][:cluster] == 'localhost'
  servers = {}
else
  servers = data_bag_item('zookeeper', node[:zookeeper][:cluster])['servers']
  # Add servers to /etc/hosts file
  servers.each do |fqdn, info|
    ip = info['ip']
    hostsfile_entry ip do
      action :create
      hostname fqdn
      aliases [ fqdn.split('.')[0] ]
    end
  end
end

# Install the deb and setup the service
# Zookeeper depends on java so will install it but the default is installing openjdk-6, this forces 7
# though it would be better to do this in the package, this change is easier than building custom packages
package 'openjdk-7-jre-headless' do
  action :install
end
#   - the zookeeper user/group are created by the deb
package 'zookeeper' do
  action :install
end

cookbook_file '/etc/init/zookeeper.conf' do
  action :create
  source "zookeeper.conf"
  owner 'root'
  group 'root'
  mode "664"
end

service "zookeeper" do
  action :enable
  provider Chef::Provider::Service::Upstart
end

# Write out the config
conf_dir = "/etc/zookeeper/conf"
# the package makes this as a link to the example
link conf_dir do
  action :delete
  only_if "test -L #{conf_dir}"
end
directory conf_dir do
  action :create
  owner "root"
  group "root"
  mode 0755
end
  
template "#{conf_dir}/zoo.cfg" do
  action :create
  source "zoo.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :servers => servers
  )
  notifies :restart, "service[zookeeper]"
end

if node[:zookeeper][:cluster] != 'localhost' 
  file "#{conf_dir}/myid" do
    action :create
    content servers[node[:fqdn]]['id'].to_s
    notifies :restart, "service[zookeeper]"
  end
end

template "#{conf_dir}/environment" do
  action :create
  source "environment.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[zookeeper]"
end

# Setup logging
directory node[:zookeeper][:log_dir] do
  action :create
  owner "zookeeper"
  group "zookeeper"
  mode 0755
end

cookbook_file "#{conf_dir}/log4j.properties" do
  action :create
  source "log4j.properties"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[zookeeper]", :immediately  # Zookeeper must be up before kafka
end
