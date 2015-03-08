#
# Cookbook Name:: apache101
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
require 'spec_helper'

describe 'apache101::default' do
  context 'When default recipe runs' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0')
      runner.converge(described_recipe)
    end

    it 'installs apache package' do
      expect(chef_run).to install_package('httpd-devel')
    end

    it 'drops the coustom home page' do
      expect(chef_run).to render_file('/var/www/html/index.html').with_content('Hello World!')
    end

    it 'enables and starts httpd service' do
      expect(chef_run).to enable_service('httpd')
      expect(chef_run).to start_service('httpd')
    end
  end
end
