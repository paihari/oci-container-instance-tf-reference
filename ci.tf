module "ci" {
  source         = "/home/bd/gh/oci_modules//container_instance"
  tenancy_id     = var.tenancy_id
  for_each       = var.ci_params
  compartment_id = var.compartment_ids[each.value.compartment_name]
  containers     = each.value.containers
  subnet_ids     = merge({ for k, v in module.sn : k => v.id }, { "public" = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaai7kmukgh2fedsperhektzup3kyl772cmdfkhoiyhnydc6uv335qq" })
  vnics          = each.value.vnics
  volumes        = each.value.volumes
}
