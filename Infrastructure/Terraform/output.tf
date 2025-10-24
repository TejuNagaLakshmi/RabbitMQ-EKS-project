output "subnet_ids" {
  description = "Public and private subnet IDs"
  value       = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.private1.id, aws_subnet.private2.id]
}

output "security_group_id" {
  description = "Security group for control plane communication with worker nodes"
  value       = aws_security_group.control_plane.id
}

output "vpc_id" {
  description = "The VPC Id"
  value       = aws_vpc.this.id
}
