#
# Cookbook Name:: apache101
# Spec:: custom_log
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'apache101::custom_log' do
  context 'When custom_log recipe runs' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0') do |node|
        node.automatic['virtualization']['system'] = 'test'
      end.converge(described_recipe)
    end

    it 'includes the `apache101::default` recipe' do
      expect(chef_run).to include_recipe('apache101::default')
    end

    it 'installs a chef_gem with httparty' do
      expect(chef_run).to install_chef_gem('httparty')
    end

    it 'Creates a coustom log configuration with attributes' do
      expect(chef_run).to create_template('/etc/httpd/conf.d/custom_log.conf').with(
        source: 'custom_log.conf.erb',
        mode: 00644,
        variables: {
          log_location: '/var/log/httpd/web_access_log',
          log_format: "%h %l %u %t \\\"%r\\\" %>s %b \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\" %{Host}i %{X-Forwarded-For}i %T/%D %I %O",
          log_format_name: 'combined_plus_host_xff_timing_io'
        }
      )
    end

    it 'Notifies apache to restart on template creation' do
      resource = chef_run.template('/etc/httpd/conf.d/custom_log.conf')
      expect(resource).to notify('service[httpd]').to(:restart).immediately
    end
  end
end
