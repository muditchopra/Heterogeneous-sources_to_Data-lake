data "aws_ami" "latest" {
  most_recent = true
  owners      = [data.aws_caller_identity.current.account_id]

  filter {
    name   = "name"
    values = [var.image_name]
  }
}
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
    values = ["com.amazonaws.ap-south-1.s3"]
  }
}
