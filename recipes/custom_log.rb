# coding: UTF-8

# Cookbook Name:: apache101
# Recipe:: custom_log

include_recipe 'apache101::default'

nodes =
  case node['virtualization']['system']
  when 'virtualpc'
    nodes = search(:node, 'role:webserver', filter_result: { name: ['name'] }) # ~FC003
    nodes.collect { |x| x['name'] + '.cloudapp.net' }
  when 'vbox'
    %w(192.168.2.50 192.168.2.51)
  when 'test'
    nil
  end

chef_gem 'httparty' do # ~FC009
  compile_time true
end
require 'httparty'

unless nodes.nil?
  nodes.each do |node|
    begin
      response = HTTParty.get("http://#{node}")
      fail "Web server not active on node #{node}" unless response.code == 200
    rescue
      raise "Connection Failure on node #{node}"
    end
  end
end

template '/etc/httpd/conf.d/custom_log.conf' do
  source 'custom_log.conf.erb'
  mode 00644
  variables(
    log_location: File.join(node['apache']['web']['log_dir'], node['apache']['web']['access_log']),
    log_format: node['apache']['web']['log_format'],
    log_format_name: node['apache']['web']['log_format_name']
  )
  notifies :restart, 'service[httpd]', :immediately
end
