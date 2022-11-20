resource "aws_security_group" "management" {
    vpc_id      = data.aws_cloudformation_export.vpc_id.value
    name        = "${lower(var.project_name)}-${lower(var.env)}-management-sg"
    description = "security group for management"

    egress {
        description      = "Allow all egress."
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${lower(var.project_name)}-${lower(var.env)}-management-sg"
    }
}

resource "aws_security_group" "mysql" {
    vpc_id      = data.aws_cloudformation_export.vpc_id.value
    name        = "${lower(var.project_name)}-${lower(var.env)}-mysql-sg"
    description = "security group for mysql servers"

    egress {
        description      = "Allow all egress."
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${lower(var.project_name)}-${lower(var.env)}-mysql-sg"
    }
    lifecycle {
        ignore_changes = [ingress, egress]
    }
}