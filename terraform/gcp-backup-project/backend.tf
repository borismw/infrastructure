terraform {
  backend "gcs" {
    project = "prajapati-iac"
    bucket  = "vishnu-iac"
    prefix  = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.7.0"
    }
  }
}
