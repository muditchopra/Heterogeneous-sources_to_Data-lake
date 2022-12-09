
resource "aws_glue_job" "job" {
  name     = "${lower(var.project_name)}-datalake-job"
  role_arn = aws_iam_role.datalake.arn

  command {
    script_location = "s3://${lower(var.env)}-${lower(var.project_name)}-scripts-${var.aws_region}/scripts/glue-job-rds-data.py"
  }
}

resource "aws_glue_job" "job2" {
  name     = "${lower(var.project_name)}-dataload-job"
  role_arn = aws_iam_role.datalake.arn

  command {
    script_location = "s3://${lower(var.env)}-${lower(var.project_name)}-scripts-${var.aws_region}/scripts/data-load.py"
  }
}