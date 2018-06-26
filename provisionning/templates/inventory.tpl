[ucp_managers]
${master_hosts}

[ucp_workers]
${worker_hosts}

[ucp:children]
ucp_managers
ucp_workers

[dtr:children]
ucp_workers
