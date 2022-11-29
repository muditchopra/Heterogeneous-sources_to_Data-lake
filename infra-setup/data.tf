data "aws_caller_identity" "current" {}

data "aws_iam_policy" "AWSGlueServiceRole" {
  name =  "AWSGlueServiceRole"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_ec2_managed_prefix_list" "s3" {
  filter {
  	name = "prefix-list-name"
    values = ["com.amazonaws.us-east-1.s3"] 
  }
}

data "aws_kms_alias" "s3" {
  name = "alias/core/s3"
}

data "aws_db_subnet_group" "database" {
  name = "rds-ec2-db-subnet-group-1"
}

data "aws_ssm_parameter" "vpcid" {
  name = "corevpcid"
}

data "aws_ssm_parameter" "vpcsubnet" {
  name = "vpcsubnet"
}

data "aws_s3_bucket" "s3" {
  bucket = "prod-tyropower-datalake-us-east-1"
}