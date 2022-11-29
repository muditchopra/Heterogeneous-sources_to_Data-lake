# KMS Key for mysql
resource "aws_kms_key" "mysql" {}

resource "aws_kms_alias" "mysql" {
  name          = "alias/${lower(var.project_name)}-${lower(var.env)}-mysql"
  target_key_id = aws_kms_key.mysql.key_id
}

resource "aws_ssm_parameter" "rds_mysql_host_reader" {
    depends_on = [aws_db_instance.mysql]
    name   = "/${lower(var.project_name)}/${lower(var.env)}/mysql/host/reader"
    type   = "SecureString"
    value  = aws_db_instance.mysql.endpoint
    key_id = aws_kms_key.mysql.arn
}

# Allow incoming connection from Management instance
resource "aws_security_group_rule" "management" {
    type                     = "ingress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "TCP"
    source_security_group_id = aws_security_group.management.id
    security_group_id        = aws_security_group.mysql.id
}

resource "aws_security_group_rule" "jenkins" {
    type                     = "ingress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "TCP"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.mysql.id
}

resource "aws_db_instance" "mysql" {
  identifier                = "${lower(var.project_name)}-${lower(var.env)}"
  engine                    = "mysql"
  engine_version            = "8.0.28"
  instance_class            = "db.t3.micro"
  multi_az                  = false
  availability_zone        = "us-east-1c"
  allocated_storage         = 20
  db_name                   = var.rds_mysql.app.database
  username                  = var.rds_mysql.master.username
  password                  = var.rds_mysql.master.password
  vpc_security_group_ids    = [ aws_security_group.mysql.id ]
  db_subnet_group_name      = data.aws_db_subnet_group.database.name
  storage_encrypted         = true
  kms_key_id                = aws_kms_key.mysql.arn
}