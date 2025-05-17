terraform {
  backend "s3" {
    bucket = "terraform"
    key    = "kubernetes/terraform.tfstate"
    region = "ap-southeast-2"

    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    use_path_style              = true
    encrypt                     = false
    use_lockfile                = true
  }
}
