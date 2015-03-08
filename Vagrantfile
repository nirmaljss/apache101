# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

@boxes = {
  centos70: { box: 'chef/centos-7.0' }
}

@network = {
  chef:         { ip: '192.168.2.52', hostname: 'chef' },
  apache01:     { ip: '192.168.2.50', hostname: 'apache01' },
  apache02:     { ip: '192.168.2.51', hostname: 'apache02' }
}

@chefip = @network[:chef][:ip]

def set_box(config, name)
  config.vm.box = @boxes[name][:box]
  config.vm.box_url = @boxes[name][:box_url]
end

def network(config, name)
  config.vm.hostname = "#{@network[name][:hostname]}.test.local"
  config.vm.network :private_network, ip: @network[name][:ip]
end

def chef_defaults(chef, name)
  chef.chef_server_url = "http://#{@chefip}:4000/organizations/main"
  chef.validation_key_path = 'vagrant/fake-key.pem'
  chef.node_name = name.to_s
end

Vagrant.configure('2') do |config|
  set_box config, :centos70

  if Vagrant.has_plugin? 'vagrant-berkshelf'
    config.berkshelf.enabled = false
    # https://github.com/berkshelf/vagrant-berkshelf/issues/180
    config.berkshelf.berksfile_path = 'this_is_a_deprecated_plugin_and_i_do_not_want_to_use_it'
  end

  config.vm.define :chef do |cfg|
    config.omnibus.chef_version = nil
    cfg.vm.provision :shell, inline: <<-'SCRIPT'.gsub(/^\s+/, '')
      yum -y install git
      rpm -q chefdk || rpm -Uvh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.3.5-1.x86_64.rpm
    SCRIPT
    if ENV['KNIFE_ONLY']
      cfg.vm.provision :shell, inline: 'cd /vagrant/vagrant; mv nodes .nodes.bak', privileged: false
    else
      cfg.vm.provision :shell, inline: 'kill -9 $(ps f -fA | grep [c]hef-zero | awk \'{print $2}\'); echo "killed chef-zero"', privileged: false
    end
    cfg.vm.provision :shell, inline: <<-'SCRIPT'.gsub(/^\s+/, ''), privileged: false
      export PATH=$PATH:/opt/chefdk/bin:/opt/chefdk/embedded/bin
      nohup chef-zero --multi-org -H 0.0.0.0 -p 4000 2>&1 > /dev/null &
      cd /vagrant/vagrant
      knife exec -E 'org_desc = {"name"  => "main"}; new_org = api.post("/organizations", org_desc);' -s http://127.0.0.1:4000/
      find roles/ -iname *.rb -exec knife role from file {} \;
      berks install -b ../Berksfile
      berks upload -b ../Berksfile --no-freeze
    SCRIPT
    network cfg, :chef
  end

  config.vm.define :apache01 do |cfg|
    cfg.omnibus.chef_version = :latest
    cfg.vm.provision :chef_client do |chef|
      chef_defaults chef, :apache01
      chef.add_role 'webserver'
    end
    network cfg, :apache01
  end

  config.vm.define :apache02 do |cfg|
    cfg.omnibus.chef_version = :latest
    cfg.vm.provision :chef_client do |chef|
      chef_defaults chef, :apache02
      chef.add_role 'webserver'
    end
    network cfg, :apache02
  end
end
