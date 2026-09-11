terraform {
  backend "s3" {
    bucket       = "devops-bootcamp-terraform-amirul"
    key          = "project1/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}   