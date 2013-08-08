directory "/var/www/wordpress/wp-content/uploads" do
  owner "apache"
  group "apache"
  mode 0755
end

execute "killall redis-server; redis-server &"



  
