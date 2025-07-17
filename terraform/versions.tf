terraform {
  required_version = ">=1.3.0"

  required_providers {

    opennebula = {
      source  = "OpenNebula/opennebula"
      version = "~> 1.4"
    }
  }
}
