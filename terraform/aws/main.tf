provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "mi-bucket-ejemplo-carlosacosta"
  acl    = "private"
}
