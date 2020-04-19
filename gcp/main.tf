data "google_compute_image" "hashicorp_server" {
  family = var.server_base_image
}

resource "google_compute_health_check" "hashicorp" {
  for_each = toset(["consul", "vault", "nomad"])

  name                = "${each.value}-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  tcp_health_check {
    port_name = each.value
  }
}

resource "google_compute_target_pool" "hashicorp" {
  for_each = toset(["consul", "vault", "nomad"])

  name          = "${each.value}-pool"
  health_checks = [google_compute_health_check.hashicorp[each.value].name]
}

resource "google_compute_region_instance_group_manager" "server" {
  name = "hashicorp-servers-igm"

  base_instance_name        = var.server_base_name
  region                    = var.server_region
  distribution_policy_zones = (var.server_zones != null) ? var.server_zones : local.all_zones[var.server_region]

  version {
    instance_template = google_compute_instance_template.hashicorp_server.self_link
  }

  target_pools = [
    google_compute_target_pool.hashicorp["consul"].self_link,
    google_compute_target_pool.hashicorp["vault"].self_link,
    google_compute_target_pool.hashicorp["nomad"].self_link,
  ]
  target_size = var.server_count

  named_port {
    name     = "consul"
    port     = 8501
  }

  named_port {
    name     = "vault"
    port     = 8200
  }

  named_port {
    name     = "nomad"
    port     = 4646
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.hashicorp["consul"].self_link
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_template" "hashicorp_server" {
  name        = "hashicorp-server-template"
  description = "Hashicorp server, running Consul, Vault, and Nomad"

  tags = ["hashicorp-server"]

  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = data.google_compute_image.hashicorp_server.self_link
  }

  network_interface {
    network = "default"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
