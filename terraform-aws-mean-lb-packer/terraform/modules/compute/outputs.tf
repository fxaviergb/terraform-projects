output "public_ips" {
  value = [aws_instance.mean_app.public_ip, aws_instance.mean_app_2.public_ip, aws_instance.mongodb.public_ip]
}

output "private_ips" {
  value = [aws_instance.mean_app.private_ip, aws_instance.mean_app_2.private_ip, aws_instance.mongodb.private_ip]
}

output "mean_app_id" {
  description = "ID de la instancia MEAN App"
  value       = aws_instance.mean_app.id
}

output "mean_app_id_2" {
  description = "ID de la instancia MEAN App 2"
  value       = aws_instance.mean_app_2.id
}

output "mongodb_id" {
  description = "ID de la instancia MongoDB"
  value       = aws_instance.mongodb.id
}
