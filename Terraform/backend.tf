terraform {
  backend "s3" {
    bucket         = "terraforms3marobucket"
    key            = "prod/terraform.tfstate" #hi
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
