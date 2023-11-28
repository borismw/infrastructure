terraform {
  backend "gcs" {
    bucket = "prajapati-iac"
    prefix = "terraform/state"
  }
}
