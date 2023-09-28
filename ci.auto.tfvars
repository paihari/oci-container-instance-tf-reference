ci_params = {
  ci = {
    compartment_name = "landing_zone"
    containers = {
      # c1 = {
      #		image_url                      = "docker.io/dpage/pgadmin4"
      #		display_name                   = "pgadmin"
      #		is_resource_principal_disabled = "false"
      #		env_vars = {
      #		  "PGADMIN_DEFAULT_EMAIL"    = "bogdan.m.darie@oracle.com"
      #		  "PGADMIN_DEFAULT_PASSWORD" = "changeme"
      #		}
      # },
      c2 = {
	display_name                   = "windmill_server"
	image_url                      = "ghcr.io/windmill-labs/windmill:main"
	is_resource_principal_disabled = "false"
	env_vars = {
	  "DATABASE_URL"       = "postgres://postgres:changeme@10.1.20.157:5432/postgres?sslmode=disable"
	  "DISABLE_SERVER"     = "false"
	  "METRICS_ADDR"       = "false"
	  "NUM_WORKERS"        = "0"
	  "REQUEST_SIZE_LIMIT" = "50097152"
	  "RUST_BACKTRACE"     = "full"
	  "RUST_LOG"           = "debug"
	}
	volume_mounts = {
	  v1 = {
	    mount_path  = "/usr/src/app/test"
	    volume_name = "v1"
	  }
	}
	working_directory = "/usr/src/app"
      }
    }
    vnics = {
      subnet_name            = "public"
      skip_source_dest_check = "true"
      is_public_ip_assigned  = true
    },
    volumes = {
      v1 = {
	name        = "v1"
	volume_type = "CONFIGFILE"
	configs = [{
	  file_name = "oauth.json"
	  data      = "./oauth.json"
	}]
      },
      v2 = {
	name          = "v2"
	volume_type   = "EMPTYDIR"
	backing_store = "EPHEMERAL_STORAGE"
      }
    }
  }
}
