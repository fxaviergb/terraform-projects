#!/bin/bash
set -e

# Actualizar e instalar Node.js
sudo apt-get update -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs nginx

echo "NodeJS instalado correctamente."

# Instalar y configurar Nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/app
server {
  listen 80;
  server_name _;
  location / {
    proxy_pass http://localhost:3000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
  }
}
EOF
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
sudo nginx -t && sudo systemctl restart nginx

echo "Nginx configurado correctamente."

# Instalar PM2
sudo npm install -g pm2

# Crear aplicación Node.js
mkdir -p /home/ubuntu/app
cat <<EOF > /home/ubuntu/app/server.js
const http = require('http');
const server = http.createServer((req, res) => {
  if (req.url === '/' && req.method === 'GET') {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('<html><body style="font-size:18px;">Hola <span style="color:blue;">MUNDO</span>. Se reporta <span style="color:green;">Fernando Xavier</span>!</body></html>');
  } else {
    res.writeHead(404, {'Content-Type': 'text/plain'});
    res.end('Uuups! Esta ruta no existe.');
  }
});
server.listen(3000, () => console.log('Server running on port 3000'));
EOF

# Configurar PM2
sudo chown -R ubuntu:ubuntu /home/ubuntu/app
pm2 start /home/ubuntu/app/server.js --name server
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "PM2 configurado correctamente."