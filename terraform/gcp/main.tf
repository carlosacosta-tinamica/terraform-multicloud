provider "google" {
  project = "TU_PROJECT_ID"
  region  = "europe-west1"
}

resource "google_storage_bucket" "bucket" {
  name     = "mi-bucket-ejemplo-carlosacosta"
  location = "EU"
}
