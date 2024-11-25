terraform {
  backend "gcs" {
    bucket = "iac-state-bucket-01"
    prefix = "infra-tf"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.64.0, < 6.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.64.0, < 6.0.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}



provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
