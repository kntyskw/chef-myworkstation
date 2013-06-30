#
# Cookbook Name:: myworkstation
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "screen"
package "git"
package "zip"
package "unzip"
package "gcc"
package "bind-utils"
package "openssl-devel"
package "libxml2-devel"
package "libxslt-devel"

user=node['user']

template "/home/#{user}/.inputrc" do
	source "inputrc.erb"
	mode 0644
	owner user
	group user
end

template "/home/#{user}/.screenrc" do
	source "screenrc.erb"
	mode 0644
	owner user
	group user
end

template "/home/#{user}/.bashrc" do
	source "bashrc.erb"
	mode 0644
	owner user
	group user
	variables(
		:accessKey => node[:aws][:accessKey],
		:secretKey => node[:aws][:secretKey],
		:region => node[:aws][:region],				
	)
end
