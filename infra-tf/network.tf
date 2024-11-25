module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.5.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-tokyo-gke"
      subnet_ip     = "10.10.6.0/23"
      subnet_private_access = "true"
      subnet_region = var.region
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name        = "subnet-tokyo-database"
      subnet_ip          = "10.10.32.0/24"
      subnet_region      = var.region
      subnet_private_access = "true"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      secondary_ip_range = []
    }
  ]
  secondary_ranges = {
    subnet-tokyo-gke = [
      {
        range_name    = "pods-range"
        ip_cidr_range = "10.10.8.0/21"
      },
      {
        range_name    = "services-range"
        ip_cidr_range = "10.10.16.0/20"
      }
    ]
  }

  ingress_rules = [
    {
      name               = "allow-internal"
      description        = "Allow internal traffic within the VPC"
      priority           = null
      source_ranges      = ["10.10.0.0/16"]
      destination_ranges = []
      target_tags        = null
      allow = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        }
      ]
      deny       = []
      log_config = null
      disabled   = false
    },
    {
      name               = "allow-ssh"
      description        = "Allow SSH access for debugging (restricted)"
      priority           = null
      source_ranges      = ["0.0.0.0/0"]
      destination_ranges = []
      target_tags        = ["ssh-access"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      deny       = []
      log_config = null
      disabled   = false
    },
    {
      name               = "allow-http"
      description        = "Allow HTTP/HTTPS access for Ingress Load Balancer"
      priority           = null
      source_ranges      = ["0.0.0.0/0"]
      destination_ranges = []
      target_tags        = ["http-access"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80"]
        },
        {
          protocol = "tcp"
          ports    = ["443"]
        }
      ]
      deny       = []
      log_config = null
      disabled   = false
    }
  ]
  egress_rules = [
    {
      name               = "allow-internet-access"
      description        = "Allow egress traffic to the internet"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      source_ranges      = ["10.10.6.0/23"]
      target_tags        = ["internet-allowed"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80", "443"] # HTTP and HTTPS
        }
      ]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name               = "allow-all-internal-egress"
      description        = "Allow egress traffic within the VPC"
      priority           = 1000
      destination_ranges = ["10.10.0.0/16"]
      source_ranges      = ["10.10.0.0/16"]
      allow = [
        {
          protocol = "all"
        }
      ]
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }
  ]
}
