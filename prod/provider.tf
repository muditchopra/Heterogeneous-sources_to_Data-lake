provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "prod-tyropower-terraform-state-ap-south-1-094597067967"
    key            = "statefile/tyropower-prod.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "prod-tyropower-terraform-state"
  }
}