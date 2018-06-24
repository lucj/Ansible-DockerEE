variable "do_token" {
  description = "Token for Digitalocean API"
  default = ""
}
variable "do_region" {
  description = "Digitalocean region"
  default = "lon1"
}
variable "do_droplet_image" {
  description = "OS Image"
  default = "ubuntu-14-04-x64"
}
variable "do_droplet_size" {
  description = "Droplet size"
  default = "2gb"
}
variable "do_droplet_prefix" {
  description = "Prefix for droplets"
  default = "ucp"
}
variable "do_ssh_key" {
  description = "SSH Key to deploy on droplet creation"
  default = ["FINGER_PRINTS_OR_IDS_OF_YOUR_SSH_KEY"]
}
variable "ucp_master_number" {
  description = "Number of master nodes"
  default = 1
}
variable "ucp_worker_number" {
  description = "Number of worker nodes"
  default = 2
}
