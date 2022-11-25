provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "prod-tyropower-terraform-state-us-east-1-094597067967"
    key            = "statefile/tyropower-prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prod-tyropower-terraform-state"
  }
}