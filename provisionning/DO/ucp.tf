# variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

# Create master nodes
resource "digitalocean_droplet" "ucp_master" {
  count = "${var.ucp_master_number}"
  image = "${var.do_droplet_image}"
  name = "${var.do_droplet_prefix}-master-${count.index+1}"
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  ssh_keys = "${var.do_ssh_key}"
}
output "ucp_master" {
  value = "${digitalocean_droplet.ucp_master.*.ipv4_address}"
}

# Create worker nodes
resource "digitalocean_droplet" "ucp_worker" {
  count = "${var.ucp_worker_number}"
  image = "${var.do_droplet_image}"
  name = "${var.do_droplet_prefix}-worker-${count.index+1}"
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  ssh_keys = "${var.do_ssh_key}"
}
output "ucp_worker" {
  value = "${digitalocean_droplet.ucp_worker.*.ipv4_address}"
}

## Output
resource "template_file" "master_ansible" {
  count = "${var.ucp_master_number}"
  template = "$${name} $${ip} $${role}"
  vars {
    name  = "${var.do_droplet_prefix}-master-${count.index+1}"
    ip = "ansible_host=${element(digitalocean_droplet.ucp_master.*.ipv4_address, count.index)}"
    role = "${count.index == 0 ? "ucp_leader=1" : "ucp_manager=1"}"
  }
}

resource "template_file" "worker_ansible" {
  count = "${var.ucp_worker_number}"
  template = "${count.index < 3 ? "$${name} $${ip} $${role}" : "$${name} $${ip}"}"
  vars {
    name  = "${var.do_droplet_prefix}-worker-${count.index+1}"
    ip = "ansible_host=${element(digitalocean_droplet.ucp_worker.*.ipv4_address, count.index)}"
    role = "${count.index == 0 ? "dtr_leader=1" : "dtr_replica=1"}"
  }
}

resource "template_dir" "inventory" {
  source_dir = "${path.module}/templates"
  destination_dir = "../../configuration/do-tf-inventories"

  vars {
    master_hosts = "${join("\n",template_file.master_ansible.*.rendered)}"
    worker_hosts = "${join("\n",template_file.worker_ansible.*.rendered)}"
  }
}
