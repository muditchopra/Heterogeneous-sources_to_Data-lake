
resource "aws_security_group_rule" "glue-rds-inbound" {
    type                     = "ingress"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "TCP"
    source_security_group_id = aws_security_group.mysql.id
    security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "glue-rds-outbound" {
    type                     = "egress"
    from_port                = 0
    to_port                  = 65535
    protocol                 = "TCP"
    source_security_group_id = aws_security_group.mysql.id
    security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "glue-s3" {
    type                     = "egress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "TCP"
    prefix_list_ids          = [data.aws_ec2_managed_prefix_list.s3.id]
    security_group_id        = aws_security_group.mysql.id
}

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = data.aws_ssm_parameter.vpcid.value
#   service_name = "com.amazonaws.us-east-1.s3"
# }

resource "aws_glue_catalog_database" "catalog_database" {
  name = "${lower(var.project_name)}-${lower(var.env)}-catalog-db"
  description = ""
}

resource "aws_glue_connection" "jdbc-connection" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${8aws_db_instance.mysql.endpoint}/${lower(var.project_name)}"
    PASSWORD            = var.rds_mysql.app.password
    USERNAME            = var.rds_mysql.app.username
  }

  name = "${lower(var.project_name)}-${lower(var.env)}-jdbc-connection"

  physical_connection_requirements {
    security_group_id_list = [aws_security_group.mysql.id]
    subnet_id              = data.aws_ssm_parameter.vpcsubnet.value
  }
}


resource "aws_lakeformation_resource" "s3-datalake" {
  arn = data.aws_s3_bucket.s3.arn
}
