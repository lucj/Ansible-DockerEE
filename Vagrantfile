# -*- mode: ruby -*-
# vi: set ft=ruby :

# global stuff
network_conn   = "en0: Wi-Fi (AirPort)"
ip_prefix = "192.168.1"

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Hello"

  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 1
  end

  # UCP Controller
  config.vm.define "ucp1" do |ucp|
    ucp.vm.hostname = "ucp1"
    ucp.vm.box = "ubuntu/trusty64"
    ucp.vm.network "public_network", ip: ip_prefix + ".230", bridge: network_conn
  end
  config.vm.define "ucp2" do |ucp|
    ucp.vm.hostname = "ucp2"
    ucp.vm.box = "ubuntu/trusty64"
    ucp.vm.network "public_network", ip: ip_prefix + ".231", bridge: network_conn
  end
  config.vm.define "ucp3" do |ucp|
    ucp.vm.hostname = "ucp3"
    ucp.vm.box = "ubuntu/trusty64"
    ucp.vm.network "public_network", ip: ip_prefix + ".232", bridge: network_conn
  end

  # UCP Workers
  config.vm.define "worker1" do |worker|
    worker.vm.hostname = "worker1"
    worker.vm.box = "ubuntu/trusty64"
    worker.vm.network "public_network", ip: ip_prefix + ".233", bridge: network_conn
  end
  config.vm.define "worker2" do |worker|
    worker.vm.hostname = "worker2"
    worker.vm.box = "ubuntu/trusty64"
    worker.vm.network "public_network", ip: ip_prefix + ".234", bridge: network_conn
  end
  config.vm.define "worker3" do |worker|
    worker.vm.hostname = "worker3"
    worker.vm.box = "ubuntu/trusty64"
    worker.vm.network "public_network", ip: ip_prefix + ".235", bridge: network_conn
  end

end
