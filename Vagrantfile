# -*- mode: ruby -*-
# vi: set ft=ruby :

# Obtain the cwd
dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# Define the list of machines to run
machines_list=[
    {
        :hostname => "master",
        :box => "centos/8",
        :ram => 1024,
        :cpu => 2,
        :priv_ip => "10.10.10.10",
    },
    {
        :hostname => "slave-bravo",
        :box => "centos/8",
        :ram => 512,
        :cpu => 2,
        :priv_ip => "10.10.10.11",
    },
    {
        :hostname => "slave-charlie",
        :box => "centos/8",
        :ram => 512,
        :cpu => 2,
        :priv_ip => "10.10.10.12",
    }
]

# Set up the Vagrant VMs
Vagrant.configure("2") do |config|
    machines_list.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.ssh.forward_agent = true
#            node.vm.network :private_network, :ip => machine[:priv_ip]
            node.vm.provider :libvirt do |virt|
                virt.memory = machine[:ram]
                virt.cpus = machine[:cpu]
                virt.cputopology :sockets => '1', :cores => machine[:cpu], :threads => '1'
#                virt.qemu_use_session = false
#                virt.uri = 'qemu:///system'
            end
            if File.exists?(File.join(vagrant_dir,'scripts/provision.sh')) then
                node.vm.provision :shell, privileged: false, :path => File.join( "scripts/provision.sh" )
            end
            if File.exists?(File.join(vagrant_dir,'scripts/echo_address.sh')) then
                node.vm.provision :shell, privileged: false, :path => File.join( "scripts/echo_address.sh" )
            end
        end
    end
end
