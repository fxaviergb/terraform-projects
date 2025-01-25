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

  location /angular {
    proxy_pass http://localhost:4000;
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

# Instalar PM2 y Express
sudo npm install -g pm2
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app
npm init -y
npm install express --save

# Crear aplicación con Express
cat <<EOF > /home/ubuntu/app/server.js
const express = require('express');
const app = express();

// Middleware para manejar datos JSON
app.use(express.json());

// Ruta principal
app.get('/', (req, res) => {
  res.send('<html><body style="font-size:18px;">Hola <span style="color:blue;">MUNDO</span>. Express está funcionando correctamente.</body></html>');
});

// Ruta adicional para datos de ejemplo
app.get('/api/data', (req, res) => {
  const data = [{ id: 1, name: 'Juan', age: 30 }];
  res.json(data);
});

// Puerto de escucha
const PORT = 3000;
app.listen(PORT, () => {
  console.log(\`Server running on http://localhost:\${PORT}\`);
});
EOF

# Configurar PM2 para la app Express
sudo chown -R ubuntu:ubuntu /home/ubuntu/app
pm2 start /home/ubuntu/app/server.js --name express-server
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "PM2 configurado correctamente con Express."

# Instalar Angular CLI globalmente
sudo npm install -g @angular/cli

# Crear proyecto Angular
mkdir -p /home/ubuntu
cd /home/ubuntu
ng new angular-app --defaults --skip-git
cd /home/ubuntu/angular-app

# Servir la aplicación Angular en el puerto 4000
cat <<EOF > /home/ubuntu/angular-app/angular.json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "projects": {
    "angular-app": {
      "architect": {
        "serve": {
          "options": {
            "port": 4000
          }
        }
      }
    }
  }
}
EOF

# Iniciar la aplicación Angular con PM2
pm2 start "ng serve --host 0.0.0.0 --port 4000" --name angular-app
pm2 save

echo "Angular configurado correctamente y corriendo en el puerto 4000."
