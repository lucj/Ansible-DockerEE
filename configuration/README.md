Deployment of Docker Datacenter
-------------------------------

This playbook setup DockerEE
* installation of docker daemon ee
* installation of Universal Control Plane
* installation of Docker Trusted Registry

Inventory
---------

The inventory.ini file defines the host the server needs to be deployed on.

The following example of inventory.ini file defines:

- 3 UCP managers
  The cluster will be initialized on the node flagged with ucp_leader=1.
  The other managers are identified with ucp_manager=1

- 5 UCP workers
  3 of those workers will be used for the deloiement of DTR.
  The registry will be installed on the node flagged with dtr_leader=1. The replica are identified with dtr_replica=1.
  The remaining nodes will be used to run the applications workloads
  

```
[ucp_managers]
192.168.0.230 ucp_leader=1
192.168.0.231 ucp_manager=1
192.168.0.232 ucp_manager=1

[ucp_workers]
192.168.0.233 dtr_leader=1
192.168.0.234 dtr_replica=1
192.168.0.235 dtr_replica=1
192.168.0.236
192.168.0.237

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


Running options
---------------

TODO:
ansible-playbook -i inventory.ini.dev -k -u root setup.yml
ansible-playbook -i inventory.ini.dev --private-key=id_rsa -u deploy deploy.yml



Several possible cases depending upon the way the nodes are created:

* Vagrant VM are used for test => **vagrant** user needs to be used

  ```ansible-playbook -i inventory.ini -k -u vagrant -s deploy.yml```

Note: vagrant ssh password requested (sudo password not requested as vagrant user is authorized to sudo without password)

* root access is provided => **root** user needs to be used

  ```ansible-playbook -i inventory.ini -k -u root deploy.yml```

Note: root ssh password will be requested

* another user provided with sudo right and a password needed to issue sudo commands

  ```ansible-playbook -i inventory.ini -k -K -u USER -s deploy.yml```

Note: both user's ssh password + sudo password will be requested

* user provided with a ssh key added to its authorized_keys

   ```ansible-playbook -i inventory.ini -u USER --private-key PATH_TO_KEY -s deploy.yml```

Note: this option is usefull in the case where a ssh key is used when creating the host (AWS, DO, ...)

Split the installation
----------------------

In order to monitor the installation process, the commands can be splitted in 3 using tags:

```
ansible-playbook -i inventory.ini -t subscription [OPTS] deploy.yml
ansible-playbook -i inventory.ini -t engine [OPTS] deploy.yml
ansible-playbook -i inventory.ini -t ucp [OPTS] deploy.yml
ansible-playbook -i inventory.ini -t dtr [OPTS] deploy.yml
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
