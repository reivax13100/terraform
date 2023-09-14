terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_volume" "shared-volume" {
  name = "shared_volume"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest" # va chercher l'image d'ubuntu sur dockerhub
}

resource "docker_network" "private_network" {
  name = "my_network"
}

resource "docker_container" "controler" {
  name    = var.controler_container_name
  image   = docker_image.ubuntu.image_id
  command = ["tail", "-f", "/dev/null"]
  hostname = "controller"
  volumes {
    host_path = "c:/users/administrateur/documents/terraform/terraform/TP1/bootstrap.sh"
    container_path = "/bootstrap.sh"
  }
  networks_advanced {
    name = docker_network.private_network.name  
  }
  provisioner "local-exec" {
    command = "docker exec ${self.name} bash bootstrap.sh"
  }

}

resource "docker_container" "target1" {
  image   = docker_image.ubuntu.image_id
  name    = var.target1_container_name
  command = ["tail", "-f", "/dev/null"]
  volumes {
    host_path = "c:/users/administrateur/documents/terraform/terraform/TP1/bootstrap.sh"
    container_path = "/bootstrap.sh"
  }
  networks_advanced {
    name = docker_network.private_network.name  
  }
  provisioner "local-exec" {
    command = "docker exec ${self.name} bash bootstrap.sh"
  }
}

resource "docker_container" "target2" {
  image   = docker_image.ubuntu.image_id
  name    = var.target2_container_name
  command = ["tail", "-f", "/dev/null"]
  volumes {
    host_path = "c:/users/administrateur/documents/terraform/terraform/TP1/bootstrap.sh"
    container_path = "/bootstrap.sh"
  }
  networks_advanced {
    name = docker_network.private_network.name  
  }
  provisioner "local-exec" {
    command = "docker exec ${self.name} bash bootstrap.sh"
  }
}

