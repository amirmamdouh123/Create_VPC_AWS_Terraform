# terraform {
#   backend "s3" {
#     bucket = "mybucket"
#     key    = ""
#     region = "us-east-1"
#   }
# }

provider "aws" {
    region = "us-east-1"
}