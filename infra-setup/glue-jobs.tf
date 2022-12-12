
resource "aws_glue_job" "job" {
  name     = "${lower(var.project_name)}-datalake-job"
  role_arn = aws_iam_role.datalake.arn

  command {
    script_location = "s3://${lower(var.env)}-${lower(var.project_name)}-scripts-${var.aws_region}/scripts/glue-job-rds-data.py"
  }
  connections = [aws_glue_connection.jdbc-connection.id]
  default_arguments = {
    # ... potentially other arguments ...
    "--enable-continuous-cloudwatch-log" = "true"
    "--TempDir"                          = "s3://prod-tyropower-scripts-us-east-1/temp"
    "--job-language"                     = "python"
    "--job-bookmark-option"              = "job-bookmark-disable"
  }
}

resource "aws_glue_job" "job2" {
  name     = "${lower(var.project_name)}-dataload-job"
  role_arn = aws_iam_role.datalake.arn

  command {
    script_location = "s3://${lower(var.env)}-${lower(var.project_name)}-scripts-${var.aws_region}/scripts/data-load.py"
  }
  default_arguments = {
    # ... potentially other arguments ...
    "--enable-continuous-cloudwatch-log" = "true"
    "--TempDir"                          = "s3://prod-tyropower-scripts-us-east-1/temp"
    "--job-language"                     = "python"
    "--job-bookmark-option"              = "job-bookmark-disable"
  }
}