data "google_client_config" "default" {}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 25.0"

  project_id = var.project_id
  name       = "gke-devops-cluster-01"
  region     = var.region
  network    = module.network.network_name
  subnetwork = "subnet-tokyo-gke"

  ip_range_pods     = "pods-range"
  ip_range_services = "services-range"

  # GKE Features
  horizontal_pod_autoscaling  = true
  http_load_balancing         = true
  network_policy              = true
  enable_binary_authorization = true

  node_pools = [
    {
      name         = "webapp-default-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 50
      auto_upgrade = true
      auto_repair  = true
      image_type   = "UBUNTU_CONTAINERD"
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",   # Full access to GCP APIs
      "https://www.googleapis.com/auth/sqlservice.admin", # Required for Cloud SQL access
      "https://www.googleapis.com/auth/monitoring.write", # For Cloud Monitoring
      "https://www.googleapis.com/auth/logging.write"     # For Cloud Logging
    ]
  }
}
