terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

# Сеть
resource "yandex_vpc_network" "network" {
  name = "ha-network"
}

# Подсеть
resource "yandex_vpc_subnet" "subnet" {
  name           = "ha-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Группа виртуальных машин
resource "yandex_compute_instance_group" "ig" {
  name               = "nginx-instance-group"
  folder_id          = var.yc_folder_id
  service_account_id = var.yc_service_account_id
  instance_template {
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd8kdq6d0p8sij7h5qe3"
        size     = 20
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.subnet.id]
      nat        = true
    }

    metadata = {
      user-data = file("${path.module}/cloud-init.yaml")
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "nginx-target-group"
  }
}

# Сетевой балансировщик
resource "yandex_lb_network_load_balancer" "lb" {
  name = "nginx-lb"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig.load_balancer.0.target_group_id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}