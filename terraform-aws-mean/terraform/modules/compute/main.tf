resource "aws_instance" "mean_app" {
  ami             = var.mean_app_ami
  instance_type   = "t2.micro"
  subnet_id       = var.subnet_ids[0]
  security_groups = var.security_ids

  tags = {
    Name = "MeanAppInstance"
  }
}

resource "aws_instance" "mongodb" {
  ami             = var.mongodb_ami
  instance_type   = "t2.micro"
  subnet_id       = var.subnet_ids[1]
  security_groups = var.security_ids

  tags = {
    Name = "MongoDBInstance"
  }
}
