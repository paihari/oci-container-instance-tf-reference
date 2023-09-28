terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.5.0"
    }
  }
  required_version = ">= 1.5.0"
}
