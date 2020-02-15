resource "aws_s3_bucket" "devopsdaysmad_bucket" {
  bucket = "devopsdaysmadbucket"
  acl    = "private"

  tags = {
    Name        = "DevOpsDaysMad-Bucket"
    Environment = "Dev"
  }
}