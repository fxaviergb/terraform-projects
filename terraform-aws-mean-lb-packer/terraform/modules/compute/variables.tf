variable "vpc_id" {
  description = "ID de la VPC donde se desplegarán las instancias"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subnets donde se desplegarán las instancias"
  type        = list(string)
}

variable "security_ids" {
  description = "IDs de los grupos de seguridad para las instancias"
  type        = list(string)
}

variable "mean_app_ami" {
  description = "AMI ID para la instancia de la aplicación MEAN"
  type        = string
}

variable "mean_app_ami_2" {
  description = "AMI ID para la segunda instancia de la aplicación MEAN"
  type        = string
}

variable "mongodb_ami" {
  description = "AMI ID para la instancia de MongoDB"
  type        = string
}
