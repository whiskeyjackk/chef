#
# Cookbook Name:: skynet-base-system
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#Skynet base system

include_recipe "chef-client-cron"
include_recipe "ntp"
include_recipe "rsyslog"
include_recipe "vim"
