#
# Cookbook Name:: skynet-base
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Base server configuration for any skynet machine


include_recipe "cron"
include_recipe "vim"
include_recipe "ntp"
