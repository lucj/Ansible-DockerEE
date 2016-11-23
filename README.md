Deployment of Docker Datacenter
-------------------------------

This playbook setup a cluster of Ubuntu (14.04) hosts running
* Docker Engine CS
* Universal Control Plane
* Docker Trusted Registry

Inventory
---------

The inventory.ini file defines the host the server needs to be deployed on

The following example of inventory.ini file defines:
- 3 UCP controller (the main manager is identified with ucp_manager=1, the replicas are identified with ucp_replica=1)
- 3 UCP workers
- 3 DTR manager (the main manager is identified with dtr_manager=1, the replicas are identified with dtr_replica=1)

```
[ucp_managers]
192.168.0.230 ucp_manager=1
192.168.0.231 ucp_replica=1
192.168.0.232 ucp_replica=1

[ucp_workers]
192.168.0.233 dtr_manager=1
192.168.0.234 dtr_replica=1
192.168.0.235 dtr_replica=1

[ucp:children]
ucp_managers
ucp_workers

[dtr:children]
ucp_workers

[dtr:vars]
replica_id=13b873dfa912
```

Notes:
- the nodes are structured in groups. Only the IP addresses within the ucp_managers and ucp_workers needs to be set.
- the replica_id within the dtr:vars group is a random value that is used to setup DTR, you can leave it or pick another one.


Nodes creation
--------------

Several quick ways to create the nodes:

### Vagrant

A simple Vagrant file is provided in this repo.

```
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
```

Change the nodes_number and run ```vagrant up```
Once the machine created, get their IP address and add them in the inventory file.

### Terraform (on DigitalOcean)

A simple ucp.tf file is provided

```
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Create a web server
resource "digitalocean_droplet" "ucp" {
    count = "2"
    image = "ubuntu-14-04-x64"
    name = "ucp-${count.index+1}"
    region = "lon1"
    size = "2gb"
    ssh_keys = ["FINGER_PRINTS_OR_IDS_OF_YOUR_SSH_KEY"]
}
```

Modification that needs to be done:

- change the *count* to specify the number of node needed (total number of nodes of the ucp cluster)
- change the ssh_keys so it uses the list of the fingerprints of your keys (eg: ssh_keys = ["e9:39:8c:f0:ae:6e:c6:e2:61:31:12:83:17:6e:fd:f3"])
- run the following command using you DigitalOcean token:``` terraform apply -var="do_token=<DO_TOKEN>" ```

Note: you can of course modify the other arguments to better match your needs.

A *terraform.tfstate* file will be created, pick the IP addresses of the nodes and add them to the inventory file.

### Your way

The option above are only 2 simple and very limited ways to get you started, of course you can select other options and cloud providers.

Running options
---------------

Several possible cases depending upon the way the nodes are created:

* Vagrant VM are used for test => **vagrant** user needs to be used

  ```ansible-playbook -i inventory.ini -k -u vagrant -s main.yml```

Note: vagrant ssh password requested (sudo password not requested as vagrant user is authorized to sudo without password)

* root access is provided => **root** user needs to be used

  ```ansible-playbook -i inventory.ini -k -u root main.yml```

Note: root ssh password will be requested

* another user provided with sudo right and a password needed to issue sudo commands

  ```ansible-playbook -i inventory.ini -k -K -u USER -s main.yml```

Note: both user's ssh password + sudo password will be requested

* user provided with a ssh key added to its authorized_keys

   ```ansible-playbook -i inventory.ini -u USER --private-key PATH_TO_KEY -s main.yml```

Note: this option is usefull in the case where a ssh key is used when creating the host (AWS, DO, ...)

Split the installation
----------------------

In order to monitor the installation process, the commands can be splitted in 3 using tags:

```
ansible-playbook -i inventory.ini -t engine [OPTS] main.yml
ansible-playbook -i inventory.ini -t ucp [OPTS] main.yml
ansible-playbook -i inventory.ini -t dtr [OPTS] main.yml
```

Using the application
---------------------

Once installed, the application can be access on the following URLs

Application | URL | Comments
------------| --- | --------
UCP         | https://ucp[0] | admin / ucppassword
DTR         | https://dtr[0] |

Disclaimer
----------

This playbook is dedicated to have Docker Datacenter up and runnin, in HA mode, g within a matter of minutes.
This playbook should not be used as it is for production setup though.

Pull Requests are welcome.

License
-------

The MIT License (MIT)

Copyright (c) [2016]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
