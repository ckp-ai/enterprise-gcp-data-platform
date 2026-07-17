# Purpose: Cloud DNS failover routing for supported regional internal load balancers.
# Validate endpoint type, global access, probing behavior, TTL and client caching before production use.
variable "project_id" { type = string }
variable "managed_zone" { type = string }
variable "dns_name" { type = string }
variable "primary_ip_address" { type = string }
variable "primary_port" { type = string }
variable "primary_protocol" { type = string, default = "tcp" }
variable "primary_network_url" { type = string }
variable "primary_region" { type = string }
variable "backup_region" { type = string }
variable "backup_ip_address" { type = string }

resource "google_dns_record_set" "service_failover" {
  project      = var.project_id
  managed_zone = var.managed_zone
  name         = var.dns_name
  type         = "A"
  ttl          = 30

  routing_policy {
    primary_backup {
      trickle_ratio = 0.01

      primary {
        internal_load_balancers {
          load_balancer_type = "regionalL4ilb"
          ip_address         = var.primary_ip_address
          port               = var.primary_port
          ip_protocol        = var.primary_protocol
          network_url        = var.primary_network_url
          project            = var.project_id
          region             = var.primary_region
        }
      }

      backup_geo {
        location = var.backup_region
        rrdatas  = [var.backup_ip_address]
      }
    }
  }
}
