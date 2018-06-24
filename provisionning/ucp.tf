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

# Create worker nodes
resource "digitalocean_droplet" "ucp_worker" {
  count = "${var.ucp_worker_number}"
  image = "${var.do_droplet_image}"
  name = "${var.do_droplet_prefix}-worker-${count.index+1}"
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  ssh_keys = "${var.do_ssh_key}"
}
