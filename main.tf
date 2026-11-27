provider "google" {
  project = "roshan-project-id" 
  region = "asia-south1" 
  zone  = "asia-south1-a"
}

resource "google_compute_network" "roshan_vpc" 
{
  name = "roshan-vpc"
  auto_create_subnetworks =false
}

resource "google_compute_subnetwork" "public" {
  name = "roshan-public"
  ip_cidr_range = "10.0.1.0/24"
  region = "asia-south1"
  network= google_compute_network.roshan_vpc.id
}

resource "google_compute_subnetwork" "private" {
  name = "roshan-private"
  ip_cidr_range = "10.0.2.0/24"
  region = "asia-south1"
  network = google_compute_network.roshan_vpc.id
}

resource "google_compute_firewall" "allow_web" {
  name = "roshan-allow-web"
  network = google_compute_network.roshan_vpc.name
  allow {
    protocol = "tcp"
    ports = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_router" "router" {
  name = "roshan-router"
  network = google_compute_network.roshan_vpc.id
  region = "asia-south1"
}

resource "google_compute_router_nat" "nat" {
  name = "roshan-nat"
  router = google_compute_router.router.name
  region = "asia-south1"
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_storage_bucket" "my_bucket" {
  name = "roshan-gcp-bucket-12345" 
  location = "ASIA-SOUTH1"
}

resource "google_compute_instance" "web" {
  name = "roshan-web"
  machine_type = "e2-micro" 
  zone = "asia-south1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.private.id
  }
}
