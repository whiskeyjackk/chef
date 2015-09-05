include_recipe "apt"

package "git"

ghe_backup_path = '/var/lib/libvirt/images/ghe-backup-data/'
ghe_backup_check_path = '/usr/local/ghe-backup-checks/'

git "/usr/local/backup-utils" do
  repository "https://github.com/github/backup-utils.git"
  revision "stable"
  action :sync
end

directory ghe_backup_path do
  recursive true
end

template "/usr/local/backup-utils/backup.config" do
  source "usr/local/backup-utils/backup.config.erb"
end

cron "hourly ghe backup" do
  minute "0"
  command "/usr/local/backup-utils/bin/ghe-backup -v 2>/var/log/ghe_backup_error.log"
end

directory ghe_backup_check_path do
  recursive true
end

template ghe_backup_check_path"check_ghe_backups.sh" do
  source "usr/local/ghe-backup-checks/check_ghe_backups.sh.erb"
  variables(
    ghe_backup_dir: ghe_backup_path
  )
end

nrpe_command "check_ghe_backups" do
  command ghe_backup_check_path"check_ghe_backups.sh"
end
