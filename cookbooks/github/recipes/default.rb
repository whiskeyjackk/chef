#
# Cookbook Name:: github
# Recipe:: default
#
# All rights reserved. DigitalOcean, Inc. 2015

include_recipe "apt"
include_recipe "github::network"

package "virtinst"
package "qemu-kvm"

directory "/var/lib/libvirt/images"

ver = node["github"]["version"]

remote_file "#{Chef::Config[:file_cache_path]}/github-enterprise-#{ver}.qcow2" do
  source "https://s3-us-west-2.amazonaws.com/do-packages/14.04/github-enterprise-#{ver}.qcow2"
  checksum node["github"]["image_checksum"]
end

execute "copy initial image" do
  command "cp github-enterprise-#{ver}.qcow2 /var/lib/libvirt/images/"
  cwd Chef::Config[:file_cache_path]
  creates "/var/lib/libvirt/images/github-enterprise-#{ver}.qcow2"
end

execute "create data volume" do
  command "qemu-img create -f qcow2 /var/lib/libvirt/images/ghe-data.qcow2 #{node["github"]["vm"]["data_vol_size_gb"]}G"
  creates "/var/lib/libvirt/images/ghe-data.qcow2"
end

execute "install github vm" do
  command <<-EOF
    virt-install \
      --connect qemu:///system \
      --name=github \
      --os-type=linux \
      --os-variant=ubuntuprecise \
      --hvm \
      --noreboot \
      --cpu host \
      --vcpus=20 \
      --ram #{node["github"]["vm"]["ram"]} \
      --disk path=/var/lib/libvirt/images/github-enterprise-#{ver}.qcow2,device=disk,bus=virtio,format=qcow2 \
      --disk path=/var/lib/libvirt/images/ghe-data.qcow2,size=#{node["github"]["vm"]["data_vol_size_gb"]},device=disk,bus=virtio,format=qcow2 \
      --network bridge=#{node["github"]["vm"]["interface"]},model=virtio \
      --graphics vnc,listen=#{node["github"]["vm"]["vnc_listen_ip"]},port=#{node["github"]["vm"]["vnc_listen_port"]} \
      --autostart \
      --import
  EOF
  creates "/etc/libvirt/qemu/github.xml"
end

execute "start github vm" do
  command "virsh --connect qemu:///system start github"
  not_if "virsh domstate github | grep running"
end
