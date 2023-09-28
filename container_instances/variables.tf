variable "tenancy_id" {
  description = "tenancy ocid"
  type        = string
}

variable "compartment_id" {
  description = "Compartment OCID"
  type        = string
}

variable "ad" {
  description = "availability domain"
  type        = number
  default     = 1
}

variable "fd" {
  description = "fault domain"
  type        = number
  default     = 1
}

variable "display_name" {
  description = "(Optional) A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information."
  type        = string
  default     = "container_instance"
}

variable "container_restart_policy" {
  description = "(Optional) Container restart policy"
  type        = string
  default     = "ALWAYS"
}

variable "graceful_shutdown_timeout_in_seconds" {
  description = "(Optional) The amount of time that processes in a container have to gracefully end when the container must be stopped. For example, when you delete a container instance. After the timeout is reached, the processes are sent a signal to be deleted."
  type        = string
  default     = "0"
}

variable "state" {
  description = "(Optional) (Updatable) The target state for the Container Instance. Could be set to ACTIVE or INACTIVE."
  type        = string
  default     = "ACTIVE"
}

variable "shape" {
  description = "(Required) The shape of the container instance. The shape determines the resources available to the container instance."
  type        = string
  default     = "CI.Standard.E4.Flex"
}

variable "shape_config" {
  description = "(Required) The size and amount of resources available to the container instance."
  type = object({
    memory_in_gbs = number
    ocpus         = number
  })
  default = {
    memory_in_gbs = 1
    ocpus         = 1
  }
}

variable "containers" {
  type = map(object({
    image_url                      = string
    display_name                   = string
    env_vars                       = map(string)
    arguments                      = optional(list(string))
    command                        = optional(list(string))
    is_resource_principal_disabled = optional(string)
    resource_config = optional(object({
      memory_limit_in_gbs = number
      vcpus_limit         = number
    }))
    volume_mounts = optional(map(object({
      mount_path   = string
      volume_name  = string
      is_read_only = bool
    })))
    working_directory = optional(string)
  }))
}

variable "vnics" {
  description = "(Required) The networks available to containers on this container instance."
  type = object({
    display_name           = optional(string)
    hostname_label         = optional(string)
    is_public_ip_assigned  = optional(string)
    nsg_ids                = optional(list(string))
    private_ip             = optional(string)
    skip_source_dest_check = optional(string)
    subnet_name            = string
    freeform_tags          = optional(map(string))
  })
}

variable "subnet_ids" {
  type = map(string)
}

variable "volumes" {
  description = "volume params"
  type = map(object({
    name          = string
    volume_type   = string
    backing_store = optional(string)
    configs = optional(list(object({
      file_name = string
      data      = string
      path      = optional(string)
    })))
  }))
  default = {}
}
