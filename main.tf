locals {
 ami  = "ami-0d26eb3972b7f8c96"
 type = "t2.micro"
 gce_ssh_user = "user"
 gce_ssh_pub_key_file = "./test-key.pub"
 gce_ssh_key_file = "./test-key"

}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  # Providing local credential variables is safer
  #credentials = file("../zeta-yen-319702-2077ec417b20.json")

  project = "zeta-yen-319702"
  region  = "us-central1"
  zone    = "us-central1-c"
}


# https://amazicworld.com/overriding-variables-in-terraform/ 
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  # machine_type = "e2-medium"
  machine_type = "e2-micro"
  tags = ["http-server","https-server","web"]
  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210609"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      user        = "${local.gce_ssh_user}"
      timeout     = "500s"
      private_key = file(local.gce_ssh_key_file)
    }

    provisioner "file" {
        source = "./scripts"
        destination = "/tmp"
    }

    provisioner "file" {
        source = "../keys"
        destination = "/tmp"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/scripts/*.sh",
            "sudo /tmp/scripts/install-docker.sh",
           # "sudo /tmp/scripts/install-concorse.sh",
           
        ]
    }

  #metadata_startup_script = "echo hi > /tmp/test.txt"
  #metadata_startup_script = file("./test.sh")
    metadata = {
    ssh-keys = "${local.gce_ssh_user}:${file(local.gce_ssh_pub_key_file)}"
  }

  scheduling {
    automatic_restart   = false
    preemptible         = true
  }
}
# HTTP RULE
resource "google_compute_firewall" "default" {
  name    = "test-http"
 network = "default"
  direction = "INGRESS"
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["80", "5433", "8080", "1234", "9808", "22"]
  }

  allow {
    protocol = "icmp"
  }
  //highly unsecure use the ip of your machine
  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web"]
}
output "ip" {
 value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}
