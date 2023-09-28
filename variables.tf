variable "tenancy_id" {
  type = string
}

variable "compartment_ids" {
  type = map(string)
}

variable "vcn_params" {
  type = map(object({
    cidr_blocks      = list(string)
    display_name     = string
    dns_label        = string
    compartment_name = string
  }))

  validation {
    condition     = alltrue([for item in var.vcn_params : length(item.cidr_blocks) > 0])
    error_message = "VCN cidr blocks list cannot be empty."
  }
}

variable "internet_gateway_params" {
  type = map(object({
    display_name = optional(string)
    vcn_name     = string
  }))
  default = {}
}

variable "service_gateway_params" {
  type = map(object({
    display_name = string
    vcn_name     = string
  }))
  default = {}
}

variable "nat_gateway_params" {
  type = map(object({
    display_name = string
    vcn_name     = string
  }))
  default = {}
}

variable "route_table_params" {
  type = map(object({
    vcn_name     = string
    display_name = string
    route_rules = list(object({
      network_entity_name = string
      destination         = string
      destination_type    = string
    }))
  }))
  default = {}
}

variable "security_list_params" {
  type = map(object({
    vcn_name     = string
    display_name = optional(string)
    egress_rules = list(object({
      stateless   = string
      protocol    = string
      destination = string
      tcp_options = optional(list(object({
	min = number
	max = number
      })))
      udp_options = optional(list(object({
	min = number
	max = number
      })))
      icmp_options = optional(list(object({
	type = number
	code = number
      })))
    }))
    ingress_rules = list(object({
      stateless   = string
      protocol    = string
      source      = string
      source_type = string
      tcp_options = optional(list(object({
	min = number
	max = number
      })))
      udp_options = optional(list(object({
	min = number
	max = number
      })))
      icmp_options = optional(list(object({
	type = number
	code = number
      })))
    }))
  }))
  default = {}
}

variable "subnet_params" {
  type = map(object({
    compartment_name  = string
    display_name      = string
    cidr_block        = string
    dns_label         = string
    is_subnet_private = bool
    sl_name           = string
    rt_name           = string
    vcn_name          = string
  }))
  default = {}
}

variable "instance_params" {
  type = map(object({
    ad    = number
    fd    = optional(number)
    shape = string
    shape_config = optional(object({
      baseline_ocpu_utilization = optional(string)
      memory_in_gbs             = optional(number)
      nvmes                     = optional(number)
      ocpus                     = optional(number)
      vcpus                     = optional(number)
    }))
    hostname                 = string
    boot_volume_size         = optional(number)
    assign_public_ip         = bool
    preserve_boot_volume     = bool
    compartment_name         = string
    ssh_public_keys          = list(string)
    encrypt_in_transit       = bool
    kms_key                  = optional(string)
    image_name               = string
    subnet_name              = string
    nsg_name                 = optional(string)
    are_all_plugins_disabled = optional(bool)
    is_management_disabled   = optional(bool)
    is_monitoring_disabled   = optional(bool)
    enabled_plugins          = optional(list(string))
  }))
}

variable "image_ids" {
  type = map(string)
}

variable "nsg_params" {
  type = map(object({
    vcn_name         = string
    display_name     = string
    compartment_name = string
    rules_params = map(object({
      protocol         = string
      stateless        = string
      direction        = string
      source           = optional(string)
      source_type      = optional(string)
      destination      = optional(string)
      destination_type = optional(string)
      tcp_options = optional(list(object({
	destination_ports = list(object({
	  min = number
	  max = number
	}))
	source_ports = list(object({
	  min = number
	  max = number
	}))
      })))
      udp_options = optional(list(object({
	destination_ports = list(object({
	  min = number
	  max = number
	}))
	source_ports = list(object({
	  min = number
	  max = number
	}))
      })))
    }))
  }))
}

variable "mysql_params" {
  type = map(object({
    compartment_name        = string
    admin_password          = string
    admin_username          = string
    ad                      = number
    fd                      = optional(number)
    shape_name              = string
    configuration_name      = string
    subnet_name             = string
    is_ha                   = bool
    data_storage_size_in_gb = number
    description             = optional(string)
    display_name            = string
    port                    = optional(number)
    port_x                  = optional(number)
    hostname_label          = string
    backup_policy = optional(object({
      freeform_tags     = optional(map(string))
      is_enabled        = optional(bool)
      retention_in_days = optional(number)
      window_start_time = optional(string)
    }))
    maintenance_window_start_time = optional(string)
  }))
  default = {}
}

variable "ci_params" {
  type = map(object({
    compartment_name = string
    ad               = optional(number)
    fd               = optional(number)
    containers = map(object({
      image_url                      = string
      display_name                   = string
      env_vars                       = map(string)
      is_resource_principal_disabled = optional(string)
      resource_config = optional(object({
	memory_limit_in_gbs = number
	vcpus_limit         = number
      }))
      volume_mounts = optional(map(object({
	mount_path   = string
	volume_name  = string
	is_read_only = optional(bool)
      })))
      working_directory = optional(string)
    }))
    vnics = object({
      subnet_name           = string
      is_public_ip_assigned = bool
    })
    volumes = optional(map(object({
      name          = string
      volume_type   = string
      backing_store = optional(string)
      configs = optional(list(object({
	file_name = string
	data      = string
	path      = optional(string)
      })))
    })))
  }))
}

variable "adb_params" {
  type = map(object({
    compartment_name                     = string
    display_name                         = string
    db_name                              = string
    admin_password                       = string
    db_version                           = string
    db_workload                          = string
    autonomous_maintenance_schedule_type = string
    character_set                        = string
    cpu_core_count                       = number
    data_storage_size_in_tbs             = number
    data_safe_status                     = string
    auto_scaling_status                  = bool
    license_model                        = string
    subnet_name                          = optional(string)
    email                                = string
    is_auto_scaling_enabled              = optional(bool)
    is_auto_scaling_for_storage_enabled  = bool
    is_dedicated                         = optional(bool)
    is_free_tier                         = optional(bool)
    is_local_data_guard_enabled          = optional(bool)
    is_data_guard_enabled                = optional(bool)
    open_mode                            = string
    permission_level                     = string
    private_endpoint_label               = string
    private_endpoint_ip                  = string
    customer_contacts_email              = optional(string)
  }))
}

variable "lb_params" {
  type = map(object({
    shape            = string
    compartment_name = string
    subnet_names     = list(string)
    display_name     = string
    is_private       = bool
    shape_details = optional(object({
      maximum_bandwidth_in_mbps = number
      minimum_bandwidth_in_mbps = number
    }))
  }))
}

variable "backend_set_params" {
  type = map(object({
    health_checker = object({
      protocol          = string
      port              = optional(number)
      url_path          = string
      interval_ms       = optional(number)
      timeout_in_millis = optional(number)
      retries           = optional(number)
      return_code       = optional(number)
    })
    name   = string
    policy = string
    ssl_configuration = optional(object({
      certificate_ids         = list(string)
      cipher_suite_name       = string
      protocols               = list(string)
      server_order_preference = string
      verify_depth            = string
      verify_peer_certificate = string
    }))
  }))
  validation {
    condition = alltrue([
    for i in var.backend_set_params : can(regex("^(LEAST_CONNECTIONS|ROUND_ROBIN|IP_HASH)$", i.policy))])
    error_message = "only LEAST_CONNECTIONS, ROUND_ROBIN, IP_HASH are valid load balancer policies."
  }
}


variable "backend_params" {
  type = map(object({
    backendset_name = string
    ip_address      = string
    port            = number
    backup          = optional(string)
    drain           = optional(string)
    offline         = optional(string)
    weight          = optional(string)
  }))
}

# variable "listener_params" {
#   description = "Parameters for lb listeners"
#   type = map(object({
#     name                = string
#     port                = number
#     protocol            = string
#     routing_policy_name = string
#     hostname_names      = list(string)
#     backend_set_name    = string
#     lb_name             = string
#     rule_set_params     = list(string)
#     ssl_configuration = map(object({
#       certificate_ids         = list(string)
#       certificate_name        = string
#       cipher_suite_name       = string
#       protocols               = list(string)
#       server_order_preference = string
#       verify_depth            = string
#       verify_peer_certificate = string
#     }))
#   }))
# }

# variable "backend_sets" {
#   type = map(object({
#     name        = string
#     lb_name     = string
#     policy      = string
#     hc_port     = number
#     hc_protocol = string
#     hc_url      = string
#   }))
# }

# variable "certificates" {
#   type = map(any)
# }

# variable "backend_params" {
#   type = map(any)
# }

# variable "private_ip_instances" {
#   type = map(any)
# }
