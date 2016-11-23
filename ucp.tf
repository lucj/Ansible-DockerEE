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
}
