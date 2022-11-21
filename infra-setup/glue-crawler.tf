
# Create the Glue role
resource "aws_iam_role" "datalake" {
  name = "LakeFormationWorkflowRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "glue.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn,data.aws_iam_policy.AWSGlueServiceRole.arn]
  inline_policy {
    name = "LakeFormationWorkflow"

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                 "lakeformation:GetDataAccess",
                 "lakeformation:GrantPermissions"
             ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": ["iam:PassRole"],
            "Resource": [
                "*"
            ]
        }
    ]
})
  }
}

resource "aws_glue_crawler" "rds" {
  database_name = aws_glue_catalog_database.catalog_database.name
  name          = "${lower(var.project_name)}-${lower(var.env)}-rds"
  role          = aws_iam_role.datalake.arn

  jdbc_target {
    connection_name = aws_glue_connection.jdbc-connection.name
    path            = "tyropower/%"
  }
}

resource "aws_glue_crawler" "s3" {
  database_name = aws_glue_catalog_database.catalog_database.name
  name          = "${lower(var.project_name)}-${lower(var.env)}-s3"
  role          = aws_iam_role.datalake.arn

  s3_target {
    path = "s3://${lower(var.env)}-${lower(var.project_name)}-datalake-${var.aws_region}/bronze/data"
  }
}

resource "aws_glue_crawler" "main" {
  database_name = aws_glue_catalog_database.catalog_database.name
  name          = "${lower(var.project_name)}-${lower(var.env)}-s3-join-data"
  role          = aws_iam_role.datalake.arn

  s3_target {
    path = "s3://${lower(var.env)}-${lower(var.project_name)}-datalake-${var.aws_region}/silver/data"
  }
}