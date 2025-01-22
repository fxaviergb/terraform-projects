output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Lista de IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "nat_gateway_eip_public_ip" {
  description = "IP pública del NAT Gateway"
  value       = aws_eip.nat.public_ip
}
