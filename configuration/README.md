Deployment of Docker EE
-------------------------------

The playbooks perform the followning tasks:

* create a user with sudo rights (pre-install)
* setup RHEL subscription if needed (pre-install) 
* installation of docker daemon (deploy)
* installation of Universal Control Plane (deploy)
* installation of Docker Trusted Registry (deploy)
* installation of nDVP plugin for NetApp (nDVP-plugin)

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

[ucp:vars]
UCP_VERSION=3.0.2

[dtr:vars]
DTR_VERSION=2.5.2
replica_id=13b873dfa912

[all:vars]
RHEL_VERSION=7
RHEL_USERNAME=
RHEL_PASSWORD=
DOCKER_EE_URL=https://storebits.docker.com/ee/m/sub-xxx-yyy
UCP_USERNAME="administrator"
UCP_PASSWORD="admin123"
```

Notes:
- some additional variables are provided such as UCP and DTR versions
- the nodes are structured in groups. Only the IP addresses within the ucp_managers and ucp_workers needs to be set.
- the replica_id within the dtr:vars group is a random value that is used to setup DTR, you can leave it or pick another one.


Pre-installation
----------------

* Create "deploy" user (to be used in the following steps) and setup subscription (needed for RHEL)

```
$ ansible-playbook -i inventory.ini -k -u root pre-install.yml
```

note: the command above needs the root password, this one will not be used in the deployment steps as the public/private keys of the "deploy" user will be used instead.

Deployment in multiple steps
----------------------------

* Install Docker daemon

```
$ ansible-playbook -i inventory.ini --private-key=id_rsa -u deploy -t daemon deploy.yml
```

* Install UCP

```
$ ansible-playbook -i inventory.ini --private-key=id_rsa -u deploy -t ucp deploy.yml
```

* Install DTR

```
$ ansible-playbook -i inventory.ini --private-key=id_rsa -u deploy -t dtr deploy.yml
```

Deployment in one step
----------------------

Even if it's best to use the approach above to make sure each sequential steps went fine, it's possible to run the installation in one step (leaving apart the pre-install step).

```
ansible-playbook -i inventory.ini --private-key=id_rsa -u deploy deploy.yml
```

nDVP Storage plugin
-------------------

An additional playbook is in charge of the installation and setup of nDVP, a Docker storage plugin used to connect to an underlying NetApp LUN storage.

Notes: 
- SAN storage: the connection information to the LUN storage need to be added first in the *roles/install-nDVP/files/configSAN.json* file
- NAS storage: details to be added

```
ansible-playbook -i inventory.ini --private-key=id_rsa -u deploy nDVP-plugin.yml
```

Using the application
---------------------

Once installed, the application can be access on the following URLs

Application | URL | Comments
------------| --- | --------
UCP         | https://ucp[0] | UCP_USERNAME / UCP_PASSWORD
DTR         | https://dtr[0] |

Disclaimer
----------

This playbook is dedicated to have Docker Datacenter up and runnin, in HA mode, g within a matter of minutes.
This playbook should not be used as it is for production setup though.

Pull Requests are welcome.

License
-------

The MIT License (MIT)

Copyright (c) [2018]

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
