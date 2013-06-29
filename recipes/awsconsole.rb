include_recipe "python"
python_pip "awscli"

user = node[:user]

remote_file "#{Chef::Config[:file_cache_path]}/elastic-mapreduce-ruby.zip" do
  source "http://elasticmapreduce.s3.amazonaws.com/elastic-mapreduce-ruby.zip"
  action :create_if_missing
end

directory node[:aws][:emrcli][:directory] do
end

execute "unzip -o #{Chef::Config[:file_cache_path]}/elastic-mapreduce-ruby.zip" do
	cwd node[:aws][:emrcli][:directory]
end

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
