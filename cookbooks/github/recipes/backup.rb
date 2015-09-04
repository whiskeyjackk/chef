include_recipe "apt"

package "git"

git "/usr/local/backup-utils" do
  repository "https://github.com/github/backup-utils.git"
  revision "stable"
  action :sync
end

directory "/var/lib/libvirt/images/ghe-backup-data" do
  recursive true
end

template "/usr/local/backup-utils/backup.config" do
  source "usr/local/backup-utils/backup.config.erb"
end

cron "hourly ghe backup" do
  minute "0"
  command "/usr/local/backup-utils/bin/ghe-backup"
end
