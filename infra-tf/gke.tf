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

# Define a Google Service Account for Artifact Registry access
#resource "google_service_account" "artifact_registry_sa" {
#  account_id   = "artifact-registry-reader"
#  display_name = "Artifact Registry Reader"
#}
#
## Grant Artifact Registry permissions to the GSA
#resource "google_project_iam_member" "artifact_registry_role" {
#  project = var.project_id
#  role    = "roles/artifactregistry.reader"
#  member  = "serviceAccount:${google_service_account.artifact_registry_sa.email}"
#}
#
## Create a Kubernetes Service Account (KSA) in the GKE cluster
##resource "kubernetes_service_account" "ksa_artifact_registry" {
##  metadata {
##    name      = "artifact-registry-ksa"
##    namespace = "todo-webapp" 
##    annotations = {
##      "iam.gke.io/gcp-service-account" = google_service_account.artifact_registry_sa.email
##    }
##  }
##}
#
## Allow the GKE cluster to impersonate the GSA
#resource "google_service_account_iam_binding" "gke_workload_identity_binding" {
#  service_account_id = google_service_account.artifact_registry_sa.id
#  role               = "roles/iam.workloadIdentityUser"
#
#  members = [
#    "serviceAccount:${var.project_id}.svc.id.goog[todo-webapp/artifact-registry-ksa]",
#  ]
#}
