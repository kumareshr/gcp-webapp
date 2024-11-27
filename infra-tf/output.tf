output "network_name" {
  description = "The name of the created VPC network"
  value       = module.network.network_name
}

output "subnet_self_links" {
  description = "The self-links of the created subnets"
  value       = module.network.subnets_self_links
}

output "workloadidentity_namespace" {
  description = "identity"
  value = module.gke.identity_namespace
  
}


