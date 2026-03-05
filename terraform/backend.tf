terraform {
  backend "s3" {
    bucket = "costtracker.khalidhashim-terraform-state"
    key    = "costtracker.khalidhashim.com/terraform.tfstate" # temporary, overridden by backend-config
    region = "us-east-1"
    #dynamodb_table = "terraform-locks"
    encrypt = true
  }
}