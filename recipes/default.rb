#
# Cookbook Name:: myworkstation
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
template "/etc/yum.repos.d/qt48.yum.repo" do
	source "qt48.yum.repo"
	mode 0644
	owner 'root'
	group 'root'
end

package "screen"
package "git"
package "zip"
package "unzip"
package "gcc"
package "bind-utils"
package "openssl-devel"
package "sqlite-devel"
package "libxml2-devel"
package "libxslt-devel"
package "xorg-x11-xauth"
package "xlogo"
package "firefox"
package "qt48-qt-webkit-devel"

execute "ln -fs /opt/rh/qt48/root/usr/include/QtCore/qconfig-64.h /opt/rh/qt48/root/usr/include/QtCore/qconfig-x86_64.h"
execute "ln -fs /opt/rh/qt48/root/usr/bin/qmake-qt4 /opt/rh/qt48/root/usr/bin/qmake"
#execute ". /opt/rh/qt48/enable"
execute "ldconfig"

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
