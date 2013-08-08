include_recipe "python"
include_recipe "python::pip"
#include_recipe "python::virtualenv"

python_pip "awscli"

user = node[:user]

remote_file "#{Chef::Config[:file_cache_path]}/elastic-mapreduce-ruby.zip" do
  source "http://elasticmapreduce.s3.amazonaws.com/elastic-mapreduce-ruby.zip"
  action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/ebcli.zip" do
  source "https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.5.0.zip"
  action :create_if_missing
end

directory node[:aws][:emrcli][:directory]
directory node[:aws][:ebcli][:directory]
directory "/home/#{user}/bin"

execute "unzip -o #{Chef::Config[:file_cache_path]}/elastic-mapreduce-ruby.zip" do
	cwd node[:aws][:emrcli][:directory]
end

directory "#{Chef::Config[:file_cache_path]}/ebcli"

execute "unzip -o #{Chef::Config[:file_cache_path]}/ebcli.zip" do
	cwd "#{Chef::Config[:file_cache_path]}/ebcli"
	node[:aws][:ebcli][:directory]
end

execute "rsync -av --delete #{Chef::Config[:file_cache_path]}/ebcli/AWS-*/ #{node[:aws][:ebcli][:directory]}/"
execute "ln -fs #{node[:aws][:ebcli][:directory]}/eb/linux/python2.7/eb /home/#{user}/bin/eb"

template "/home/#{user}/credentials.json" do
	source "credentials.json.erb"
	mode 0600
	owner node[:user]
	group node[:user]
	variables(
		:accessKey => node[:aws][:accessKey],
		:secretKey => node[:aws][:secretKey],		
		:region => node[:aws][:region],
		:keypairName => node[:aws][:keypairName],
		:keypairFile => node[:aws][:keypairFile]		
	)
end

template "/home/#{user}/.awscli.config" do
	source "awscli.config.erb"
	mode 0600
	owner node[:user]
	group node[:user]
	variables(
		:accessKey => node[:aws][:accessKey],
		:secretKey => node[:aws][:secretKey],				
		:region => node[:aws][:region]		
	)
end
