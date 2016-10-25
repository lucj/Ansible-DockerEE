Deployment of Docker Datacenter
--------------------------------

This playbook setup a cluster of Ubuntu (14.04) hosts running
* Docker Engine CS
* Universal Control Plane
* Docker Trusted Registry

Inventory
---------

The inventory.ini file defines the host the server needs to be deployed on

The following exemple of inventory.ini file defines:
- 3 UCP controller (the first ucp node and the 2 nodes with the flag replica=1 under the ucp group)
- 2 UCP workers (the last 2 nodes with the flag worker=1 under the ucp group)
- 2 DTR manager (the 2 nodes within the dtr group)

```
[ucp]
192.168.0.210
192.168.0.211 ucp_replica=1
192.168.0.212 ucp_replica=1
192.168.0.213 ucp_worker=1
192.168.0.214 ucp_worker=1

[dtr]
192.168.0.213 name=worker1
192.168.0.214 name=worker2 dtr_replica=1
```

The following exemple of inventory.ini file defines:
- 1 UCP controller (the first node within the ucp group)
- 3 UCP workers (the node with ucp_worker flag in the ucp group)
- 3 DTR manager (the first node of within the dtr group and the 2 nodes with dtr_replica flag)

```
[ucp]
192.168.0.230
192.168.0.233 ucp_worker=1
192.168.0.234 ucp_worker=1
192.168.0.235 ucp_worker=1

[dtr]
192.168.0.233 name=worker1
192.168.0.234 name=worker2 dtr_replica=1
192.168.0.235 name=worker3 dtr_replica=1
```

Running option
--------------

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
