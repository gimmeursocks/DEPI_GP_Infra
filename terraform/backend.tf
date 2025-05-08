terraform {
  backend "s3" {
    bucket         = "depi-terraform-state-bucket"
    key            = "terraform/prod/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    use_lockfile   = true
  }
}
