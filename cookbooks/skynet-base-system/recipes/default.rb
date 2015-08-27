#
# Cookbook Name:: skynet-base-system
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

#Skynet base system

include_recipe "cron"
include_recipe "ntpd"
include_recipe "rsyslog"
include_recipe "vim"
