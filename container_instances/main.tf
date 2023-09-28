data "oci_identity_availability_domains" "this" {
  compartment_id = var.tenancy_id
}

resource "oci_container_instances_container_instance" "this" {
  compartment_id                       = var.compartment_id
  availability_domain                  = data.oci_identity_availability_domains.this.availability_domains[var.ad - 1].name
  fault_domain                         = format("FAULT-DOMAIN-%s", var.fd)
  display_name                         = var.display_name
  container_restart_policy             = var.container_restart_policy
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  state                                = var.state

  shape = var.shape
  shape_config {
    memory_in_gbs = var.shape_config.memory_in_gbs
    ocpus         = var.shape_config.ocpus
  }

  dynamic "containers" {
    for_each = var.containers
    content {
      image_url                      = containers.value.image_url
      display_name                   = containers.value.display_name
      is_resource_principal_disabled = containers.value.is_resource_principal_disabled
      arguments                      = containers.value.arguments
      command                        = containers.value.command
      environment_variables          = containers.value.env_vars

      dynamic "resource_config" {
	for_each = containers.value.resource_config != null ? containers.value.resource_config : {}
	content {
	  memory_limit_in_gbs = resource_config.value.memory_limit_in_gbs
	  vcpus_limit         = resource_config.value.vcpus_limit
	}
      }

      dynamic "volume_mounts" {
	for_each = containers.value.volume_mounts != null ? containers.value.volume_mounts : {}
	content {
	  mount_path   = volume_mounts.value.mount_path
	  volume_name  = volume_mounts.value.volume_name
	  is_read_only = volume_mounts.value.is_read_only
	}
      }
      working_directory = containers.value.working_directory
    }
  }

  vnics {
    display_name           = var.vnics.display_name
    hostname_label         = var.vnics.hostname_label
    is_public_ip_assigned  = var.vnics.is_public_ip_assigned
    nsg_ids                = var.vnics.nsg_ids
    private_ip             = var.vnics.private_ip
    skip_source_dest_check = var.vnics.skip_source_dest_check
    subnet_id              = var.subnet_ids[var.vnics.subnet_name]
    freeform_tags          = var.vnics.freeform_tags
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      name          = volumes.key
      volume_type   = volumes.value.volume_type
      backing_store = volumes.value.backing_store
      dynamic "configs" {
	for_each = volumes.value.configs != null ? volumes.value.configs : []
	content {
	  file_name = configs.value.file_name
	  data      = base64encode(file(configs.value.data))
	  path      = configs.value.path
	}
      }
    }
  }

  # image_pull_secrets {
  #   registry_endpoint = var.registry_endpoint
  #   secret_type       = "VAULT"
  #   secret_id         = var.secret_id
  # }

  # dns_config {
  #   nameservers = ["8.8.8.8"]
  #   options     = ["options"]
  #   searches    = ["search domain"]
  # }
}
