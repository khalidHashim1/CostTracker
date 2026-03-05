# Terraform state file bucket. 
resource "aws_s3_bucket" "TerraformStateFile" {
  bucket = "costtracker.khalidhashim-terraform-state"
}

resource "aws_s3_bucket_versioning" "TerraformStateVersioning" {
  bucket = aws_s3_bucket.TerraformStateFile.id

  versioning_configuration {
    status = "Enabled"
  }
}


#  costtracker.khalidhashim.com Bucket for static site. 
resource "aws_s3_bucket" "CostTrackerStaticSite" {
  bucket = "cost.khalidhashim.com"
}

resource "aws_s3_bucket_versioning" "CostTrackerVersioning" {
  bucket = aws_s3_bucket.CostTrackerStaticSite.id

  versioning_configuration {
    status = "Enabled"
  }
}
