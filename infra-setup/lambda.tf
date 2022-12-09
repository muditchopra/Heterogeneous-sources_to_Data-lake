resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = data.aws_s3_bucket.s3.id

  rule {
    id = "rule-1"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}


resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${lower(var.env)}-${lower(var.project_name)}-lambda"
  retention_in_days = 14
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
            ]
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.datalake.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_lambda_function" "func" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  function_name    = "${lower(var.env)}-${lower(var.project_name)}-lambda"
  role             = aws_iam_role.datalake.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.9"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.s3.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.s3.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "bronze/flatfiles/"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}