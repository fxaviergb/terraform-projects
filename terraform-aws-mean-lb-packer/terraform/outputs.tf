output "public_ips" {
  value = module.compute.public_ips
}

output "private_ips" {
  value = module.compute.private_ips
}

output "lb_dns" {
  value = module.lb.dns_name
}

output "nat_gateway_public_ip" {
  value = module.network.nat_gateway_eip_public_ip
}

