# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Hello"

  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 1
  end

  nodes_number = 3
  (1..nodes_number).each do |i|
    hostname = "ucp#{i}"
    config.vm.define hostname do |ucp|
      ucp.vm.hostname = hostname
      ucp.vm.box = "ubuntu/trusty64"
      ucp.vm.network "private_network", type: "dhcp"
    end
  end

end
