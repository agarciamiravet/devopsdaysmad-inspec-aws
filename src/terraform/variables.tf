variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-09d069a04349dc3cb"
    us-east-1 = "ami-09d069a04349dc3cb"
    us-west-1 = "ami-09d069a04349dc3cb"
    us-west-2 = "ami-09d069a04349dc3cb"
  }
}

variable "ssh_privatekey" {
  description = "Private ssh pub key file"
}
