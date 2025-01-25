#!/bin/bash
# Actualizar lista de paquetes
sudo apt update -y

# Instalar libssl1.1 manualmente
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# Importar la clave pública GPG de MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Agregar el repositorio oficial de MongoDB (usar focal como versión compatible)
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Actualizar lista de paquetes nuevamente
sudo apt update -y

# Instalar MongoDB
sudo apt install -y mongodb-org

# Habilitar y arrancar el servicio de MongoDB
sudo systemctl enable mongod
sudo systemctl start mongod

# Esperar a que el servicio de MongoDB esté listo
sleep 10

# Insertar datos en MongoDB
cat <<EOF | mongo
use mydatabase
db.personas.insertMany([
  { "nombre": "Juan", "edad": 30, "email": "juan@example.com" },
  { "nombre": "Maria", "edad": 25, "email": "maria@example.com" },
  { "nombre": "Pedro", "edad": 35, "email": "pedro@example.com" }
])
EOF

echo "Datos insertados en MongoDB exitosamente."
