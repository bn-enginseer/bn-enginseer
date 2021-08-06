terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.13.0"
    }
  }
  backend "s3" {
    bucket = "bn-digital"
    key = "terraform/bn-enginseer/terraform.tfstate"
    endpoint = "fra1.digitaloceanspaces.com"
    region = "fra1"
    skip_region_validation = true
    skip_credentials_validation = true
    skip_metadata_api_check = true
  }
}
