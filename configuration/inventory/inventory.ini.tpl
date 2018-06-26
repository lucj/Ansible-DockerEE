[ucp_managers]
master-1 ansible_host=[IP1] ucp_leader=1
master-2 ansible_host=[IP2] ucp_leader=1
master-3 ansible_host=[IP3] ucp_leader=1

[ucp_workers]
worker-1 ansible_host=[IP4] dtr_leader=1
worker-2 ansible_host=[IP5] dtr_replica=1
worker-3 ansible_host=[IP6] dtr_replica=1
worker-4 ansible_host=[IP7]
worker-5 ansible_host=[IP8]

[ucp:children]
ucp_managers
ucp_workers

[dtr:children]
ucp_workers
