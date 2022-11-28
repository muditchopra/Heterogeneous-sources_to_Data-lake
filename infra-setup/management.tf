
# Allow ssh to Managment Instance
resource "aws_security_group_rule" "management_ec2" {
    type                     = "ingress"
    from_port                = 22
    to_port                  = 22
    protocol                 = "TCP"
    cidr_blocks              = ["0.0.0.0/0"]
    security_group_id        = aws_security_group.management.id
}
##TODO subnet
resource "aws_instance" "management" {
  ami                    = "ami-0b0dcb5067f052a63"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.management.id]
  subnet_id              = data.aws_ssm_parameter.vpcsubnet.value
  user_data              = var.user_data
    tags = {
        Name = "${lower(var.project_name)}-${lower(var.env)}-management"
    }

  lifecycle {
    ignore_changes = [
      tags["tyropower"],
    ]
  }
}
