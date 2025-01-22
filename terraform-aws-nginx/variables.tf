variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI para la instancia EC2"
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  default     = "t2.micro"
}

