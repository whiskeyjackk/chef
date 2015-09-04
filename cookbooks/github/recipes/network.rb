package "bridge-utils"
package "vlan"

template "/etc/network/interfaces" do
  source "etc/network/interfaces.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end
