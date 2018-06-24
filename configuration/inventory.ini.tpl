[ucp_managers]
IP1 ucp_leader=1
IP2 ucp_manager=1
IP3 ucp_manager=1

[ucp_workers]
IP4 dtr_leader=1
IP5 dtr_replica=1
IP6 dtr_replica=1
IP7
IP8

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
RHEL_VERSION=
RHEL_USERNAME=
RHEL_PASSWORD=
DOCKER_EE_URL=
UCP_USERNAME=
UCP_PASSWORD=
