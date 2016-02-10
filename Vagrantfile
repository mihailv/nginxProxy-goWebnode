# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
    # Company
    company = 'sainsburys'
    
    # Golang webserver source code
    repo = 'github.com/mihailv'
    namespace = 'web'
    app = 'sgo_webserver'
    
    # Balancing
    webnode_ips = '10.0.0.10, 10.0.0.11'
    webnode_port = '8484'
    lb_ip = '10.0.0.12'
    
    # web nodes data
    project_path = '/opt/' + company
    webnode_gitsource = File.join(repo, namespace, app)
        
    # web nodes 1-n
    i = 0
    webnode_ips.split(',').each do |webnode_ip|
        i = i + 1
        webnode_name = 'web' + i.to_s()
        config.vm.define webnode_name do |web|
            web.vm.box = "hashicorp/precise64"
            web.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "1024"]
                vb.customize ["modifyvm", :id, "--cpus", "2"]
            end
            web.vm.network "private_network", ip: webnode_ip
            web.vm.hostname = webnode_name
            web.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
                puppet.module_path = "puppet/modules"
                puppet.manifests_path = "puppet/manifests"
                puppet.manifest_file  = "webnode.pp"
                puppet.facter = {
                    'app' => app,
                    'project_path' => project_path,
                    'webnode_source' => webnode_gitsource,
                    'webnode_port' => webnode_port
                }
            end
        end
    end
    
    # loadbalancers 1-1
    config.vm.define "lb1" do |lb1|
        lb1.vm.box = "hashicorp/precise64"
        lb1.vm.network "private_network", ip: lb_ip
        lb1.vm.hostname = 'lb1'
        lb1.vm.provision :puppet, :module_path => "puppet/modules" do |puppet|
            puppet.module_path = "puppet/modules"
            puppet.manifests_path = "puppet/manifests"
            puppet.manifest_file  = "lb.pp"
            puppet.facter = {
                'app' => app,
                'webnode_ips' => webnode_ips,
                'webnode_port' => webnode_port
            }
        end
    end
    
end
