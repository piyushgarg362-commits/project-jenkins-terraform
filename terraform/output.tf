output "public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.web.public_ip
}
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web.id
}
