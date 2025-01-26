param (
    [string]$ExecutionType = "all"
)

# Variables del proyecto
$PackerFolder = ".\packer"
$TerraformFolder = ".\terraform"
$MeanAppPackerFile = "mean-app.json"
$MongoDBPackerFile = "mongodb.json"

# Configuración inicial
Write-Host "Iniciando despliegue del proyecto MEAN en AWS..." -ForegroundColor Cyan

# Validar si AWS CLI está configurado
if (-not (Get-Command "aws" -ErrorAction SilentlyContinue)) {
    Write-Error "AWS CLI no está instalado o no está en el PATH."
    exit 1
}

# Validar si Terraform está instalado
if (-not (Get-Command "terraform" -ErrorAction SilentlyContinue)) {
    Write-Error "Terraform no está instalado o no está en el PATH."
    exit 1
}

# Validar si Packer está instalado
if (-not (Get-Command "packer" -ErrorAction SilentlyContinue)) {
    Write-Error "Packer no está instalado o no está en el PATH."
    exit 1
}

# Función para ejecutar Packer
function Execute-Packer {
    Write-Host "Creando AMI para la aplicación MEAN con Packer..." -ForegroundColor Green
    cd $PackerFolder
    packer validate $MeanAppPackerFile
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al validar el archivo Packer para MEAN App."
        exit 1
    }
    packer build $MeanAppPackerFile
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al crear la AMI para MEAN App."
        exit 1
    }

    Write-Host "Creando AMI para MongoDB con Packer..." -ForegroundColor Green
    packer validate $MongoDBPackerFile
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al validar el archivo Packer para MongoDB."
        exit 1
    }
    packer build $MongoDBPackerFile
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al crear la AMI para MongoDB."
        exit 1
    }
    cd ..

    # Extraer IDs de las AMIs creadas
    $MeanAppAmiId = (packer build $PackerFolder\$MeanAppPackerFile | Select-String "ami-" -SimpleMatch).Line
    $MongoDBAmiId = (packer build $PackerFolder\$MongoDBPackerFile | Select-String "ami-" -SimpleMatch).Line

    if (-not $MeanAppAmiId -or -not $MongoDBAmiId) {
        Write-Error "No se pudieron extraer los IDs de las AMIs. Verifica la salida de Packer."
        exit 1
    }

    Write-Host "AMIs creadas exitosamente:"
    Write-Host "  - MEAN App AMI: $MeanAppAmiId"
    Write-Host "  - MongoDB AMI: $MongoDBAmiId"

    return @($MeanAppAmiId, $MongoDBAmiId)
}

# Función para ejecutar Terraform
function Execute-Terraform {
    param (
        [string]$MeanAppAmiId,
        [string]$MongoDBAmiId
    )

    Write-Host "Preparando Terraform..." -ForegroundColor Green
    cd $TerraformFolder
    terraform init
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al inicializar Terraform."
        exit 1
    }

    # Crear el archivo `terraform.tfvars` dinámicamente
    Write-Host "Creando archivo terraform.tfvars..."
    $TfVarsContent = @"
mean_app_ami = "$MeanAppAmiId"
mongodb_ami = "$MongoDBAmiId"
"@
    Set-Content -Path "terraform.tfvars" -Value $TfVarsContent
    Write-Host "Archivo terraform.tfvars creado exitosamente."

    # Planificar y aplicar Terraform
    Write-Host "Ejecutando terraform plan..." -ForegroundColor Green
    terraform plan
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al planificar la infraestructura con Terraform."
        exit 1
    }

    Write-Host "Ejecutando terraform apply..." -ForegroundColor Green
    terraform apply -auto-approve
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error al aplicar la infraestructura con Terraform."
        exit 1
    }

    Write-Host "Infraestructura desplegada exitosamente con Terraform." -ForegroundColor Green

    # Mostrar los outputs de Terraform
    Write-Host "Mostrando salidas de Terraform..." -ForegroundColor Cyan
    terraform output
}

# Ejecutar secciones según el argumento recibido
switch ($ExecutionType.ToLower()) {
    "all" {
        $AmiIds = Execute-Packer
        Execute-Terraform -MeanAppAmiId $AmiIds[0] -MongoDBAmiId $AmiIds[1]
    }
    "packer" {
        Execute-Packer
    }
    "terraform" {
        # IDs de ejemplo, reemplaza con los reales si es necesario
        $MeanAppAmiId = "ami-0307f6831d7a34770"
        $MongoDBAmiId = "ami-043db8d119bc7ba68"
        Execute-Terraform -MeanAppAmiId $MeanAppAmiId -MongoDBAmiId $MongoDBAmiId
    }
    default {
        Write-Error "Argumento no válido. Usa 'all', 'packer' o 'terraform'."
        exit 1
    }
}

Write-Host "Despliegue completado." -ForegroundColor Cyan
