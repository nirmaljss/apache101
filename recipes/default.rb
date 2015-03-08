# coding: UTF-8

# Cookbook Name:: apache101
# Recipe:: default

# Install package
package 'httpd-devel' do
  action :install
end

# Drop custom home page
template File.join(node['apache']['web']['dir'], 'index.html') do
  source 'index.html.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Create httpd service.
service 'httpd' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
