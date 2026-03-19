output "AZ_zone" {
  value       = data.aws_availability_zones.available
}

output "vpc_id" {
  value = aws_vpc.main.id
}
