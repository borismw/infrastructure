resource "google_service_account" "restic_archive_nurgle_sa" {
  account_id   = "restic-archive-nurgle"
  display_name = "restic-archive-nurgle"
}

resource "google_storage_bucket_iam_member" "restic_archive_nurgle_role" {
  bucket = google_storage_bucket.restic_archive_nurgle.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.restic_archive_nurgle_sa.email}"
}

resource "google_storage_bucket" "restic_archive_nurgle" {
  name          = "restic_archive_nurgle"
  project       = "vishnu-backup"
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
