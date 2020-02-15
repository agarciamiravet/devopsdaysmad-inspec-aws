output "address" {
  value = aws_elb.web.dns_name
}
output "elb_id" {
  value = aws_elb.web.id
}
output "ec2_id" {
  value = aws_instance.web.id
}
output "s3_id" {
  value = aws_s3_bucket.devopsdaysmad_bucket.id
}
output "s3_name" {
  value = aws_s3_bucket.devopsdaysmad_bucket.bucket
}