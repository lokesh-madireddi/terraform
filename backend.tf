terraform {
  backend "s3" {
    bucket         = "fitness-state-s3-bucket"
    key            = "eks/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
