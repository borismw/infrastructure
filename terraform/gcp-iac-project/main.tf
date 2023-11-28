resource "google_project_service" "vishnu_iam" {
  project = "vishnu-backup"
  service = "iam.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_project_iam_custom_role" "iac_state_bucket_enumerator" {
  permissions = [
    "storage.buckets.get",
    "storage.buckets.list",
  ]
  role_id = "iacStateBucketEnumerator"
  title   = "IAC State Bucket Enumerator"
}

resource "google_project_iam_custom_role" "iac_state_bucket_editor" {
  permissions = [
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.update"
  ]
  role_id = "iacStateBucketEditor"
  title   = "IAC State Bucket Editor"
}

resource "google_storage_bucket_iam_member" "vishnu_iac_member_bucket_editor" {
  role   = google_project_iam_custom_role.iac_state_bucket_editor.id
  member = "serviceAccount:vishnu-terraform@vishnu-backup.iam.gserviceaccount.com"
  bucket = "vishnu-iac"
}

resource "google_project_iam_member" "vishnu_iac_member_bucket_enumerator" {
  project = "prajapati-iac"
  role    = google_project_iam_custom_role.iac_state_bucket_enumerator.id
  member  = "serviceAccount:vishnu-terraform@vishnu-backup.iam.gserviceaccount.com"
}

resource "google_storage_bucket" "vishnu_iac" {
  name          = "vishnu-iac"
  location      = "EUROPE-WEST1"
  force_destroy = true

  versioning {
    enabled = true
  }

  enable_object_retention = false

  autoclass {
    enabled                = true
    terminal_storage_class = "NEARLINE"
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age                        = 0
      days_since_custom_time     = 0
      days_since_noncurrent_time = 0
      matches_prefix             = []
      matches_storage_class      = []
      matches_suffix             = []
      num_newer_versions         = 3
      with_state                 = "ARCHIVED"
    }
  }
  lifecycle_rule {

    action {

      type = "Delete"
    }
    condition {
      age                        = 0
      days_since_custom_time     = 0
      days_since_noncurrent_time = 7
      matches_prefix             = []
      matches_storage_class      = []
      matches_suffix             = []
      num_newer_versions         = 0
      with_state                 = "ANY"
    }
  }

  timeouts {}
}
