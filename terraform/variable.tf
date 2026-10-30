variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}
variable "project_name" {
  type        = string
  description = "Resource name prefix"
  default     = "devops-project-2"
}
variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name in this region"
}
variable "ssh_allowed_cidr" {
  type        = string
  description = "Your public IPv4 CIDR, e.g. 203.0.113.10/32"
  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Provide a valid CIDR, such as your-public-ip/32."
  }
}
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}
