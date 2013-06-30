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

git "/tmp/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :sync
end

bash "rbenv setup" do
	cwd "/tmp/ruby-build"
	code <<-EOF
	    ./install.sh
	    source /etc/profile.d/rbenv.sh
      export CONFIGURE_OPTS="--with-openssl-dir=/usr/include/openssl"
	    rbenv install #{node[:ruby][:version]}
	    #ruby-build #{node[:ruby][:version]} /usr/local/rbenv/versions/#{node[:ruby][:version]} --with-openssl-dir=/usr/include/openssl
	    rbenv global #{node[:ruby][:version]}
	    rbenv rehash
	EOF
end



