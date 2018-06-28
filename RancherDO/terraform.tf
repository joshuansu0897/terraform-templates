# terraform.tf
# variable "do_domain" {
#   type = "string"
# }

variable "local_ssh_key_path" {
  type    = "string"
  default = "~/.ssh/id_rsa"
}

variable "digitalocean_ssh_fingerprint" {
  type = "string"
}

resource "digitalocean_droplet" "rancher-controller" {
  image              = "coreos-stable"
  name               = "rancher.${var.do_domain}"
  region             = "sfo2"
  size               = "4gb"
  ssh_keys           = ["${var.digitalocean_ssh_fingerprint}"]
  private_networking = true

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      private_key = "${file("${var.local_ssh_key_path}")}"
      user        = "core"
    }

    inline = [
      # rancher v1
      #"sudo docker run -d --restart=unless-stopped -p 80:8080 rancher/server",
      # rancher v2
      "sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher",
    ]
  }
}

# resource "digitalocean_floating_ip" "rancher-controller" {
#   droplet_id = "${digitalocean_droplet.rancher-controller.id}"
#   region     = "${digitalocean_droplet.rancher-controller.region}"
# }


# # Create a new record
# resource "digitalocean_record" "rancher-controller" {
#   name   = "rancher"
#   type   = "A"
#   domain = "${var.do_domain}"
#   ttl    = "60"
#   value  = "${digitalocean_floating_ip.rancher-controller.ip_address}"
# }

