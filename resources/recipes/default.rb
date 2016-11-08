#
# Cookbook Name:: samza
# Recipe:: default
#
# Copyright 2016, redborder
#
# All rights reserved - Do Not Redistribute
#

samza_config "config" do
  mystring "test"
  action :add
end
