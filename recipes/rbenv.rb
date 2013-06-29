user = node[:user]

git "/usr/local/rbenv" do
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :sync
end

template "/etc/profile.d/rbenv.sh" do
	source "rbenv.sh"
	mode 0755
end

git "#{Chef::Config[:file_cache_path]}/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :sync
end

bash "rbenv setup" do
	cwd "#{Chef::Config[:file_cache_path]}/ruby-build"
	code <<-EOF
	    ./install.sh
	    source /etc/profile.d/rbenv.sh
	    rbenv install #{node[:ruby][:version]}
	    rbenv global #{node[:ruby][:version]}
	    rbenv rehash
	EOF
end

gem_package "berkshelf"



