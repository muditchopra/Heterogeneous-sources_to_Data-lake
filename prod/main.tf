module "infraSetup" {
  source      = "../infra-setup"
  env = "Prod"
  
  aws_region = "ap-south-1"
  key_name = "tyropower-management-key"
  rds_mysql = {
      master = {
          username = "master"
          password = "abcdefghijklmnopqrstuvwxyz1234567890"
      },
      app = {
          username = "tyropower"
          password = "0987654321zyxwvutsrqponmlkjihgfedcba"
          database = "tyropower"
      }
  }
}