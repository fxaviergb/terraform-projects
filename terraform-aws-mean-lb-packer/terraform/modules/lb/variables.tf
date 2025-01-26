variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subnets"
  type        = list(string)
}

variable "security_ids" {
  description = "IDs de los grupos de seguridad para el balanceador"
  type        = list(string)
}

variable "mean_app_instance_id" {
  description = "ID de la instancia MEAN App"
  type        = string
}

variable "mean_app_instance_id_2" {
  description = "ID de la instancia MEAN App 2"
  type        = string
}
