variable "region" {
  default = "asia-northeast1"
}

variable "zone" {
  default = "asia-northeast1-a"
}

variable "project_id" {
  default = "stone-botany-440911-u3"
}

variable "network_name" {
  default = "vpc-tokyo-01"
  
}

variable "db_password" {
  description = "Database password for the Cloud SQL user."
  type        = string
  sensitive   = true
  default = "securepassword"
}
