#!/bin/bash
yum update -y
amazon-linux-extras enable nginx1
yum install -y nginx
echo "<h1>Bienvenido a mi servidor web desplegado con Terraform</h1>" > /usr/share/nginx/html/index.html
systemctl start nginx
systemctl enable nginx