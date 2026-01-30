# infra-bucket-s3

Terraform infrastructure for creating an S3 bucket on AWS.

## Description

This project provisions a configurable S3 bucket on AWS with the following features:

- **Criptografia**: AES256 habilitada por padrão
- **Versionamento**: Habilitado (configurável via variável)
- **Acesso Público**: Bloqueado em todos os níveis
- **Tags**: Ambiente, nome e gerenciamento via Terraform

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado ou credenciais via GitHub Secrets
- Acesso IAM à AWS com permissões para criar buckets S3

## Configuração

### Pré-requisitos

1. **Bucket Name Único**: S3 bucket names devem ser globalmente únicos. Crie um nome único antes de executar:
   - Formato recomendado: `<org>-bolsa-de-valores-<ambiente>-<random>`
   - Exemplo: `mycompany-bolsa-de-valores-prod-a1b2c3`

2. **Credenciais AWS**: Configure via GitHub Secrets ou AWS CLI

### Variáveis

Configure as variáveis antes do deploy:

**Variáveis Obrigatórias:**
- `bucket_name`: Nome ÚNICO do bucket S3 (não tem padrão, deve ser especificado)

**Variáveis Opcionais:**
- `aws_region`: Região AWS (padrão: "us-east-1")
- `environment`: Ambiente (padrão: "prod")
- `enable_versioning`: Habilitar versionamento (padrão: true)

## Deploy

### GitHub Actions (Recomendado)

O workflow `.github/workflows/terraform-deploy.yml` executa automaticamente:

**Em Pull Requests:**
- Executa `terraform plan`
- Posta o plano como comentário no PR

**Em Push para Main:**
- Executa `terraform apply`
- Cria/atualiza o bucket S3

**Configuração necessária:**
1. Adicione os seguintes secrets no GitHub:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. Configure o bucket name via GitHub Variables ou arquivo tfvars:
   - Vá em Settings → Secrets and variables → Actions → Variables
   - Adicione `TF_VAR_bucket_name` com valor único (ex: `mycompany-bolsa-de-valores-prod-xyz123`)

3. Execute o workflow (push para main ou manual via workflow_dispatch)

**⚠️ Atenção**: Este método é ideal para o deploy inicial. Para gerenciamento contínuo, recomenda-se usar backend remoto ou executar localmente.

### Deploy Manual

```bash
# Inicializar Terraform
terraform init

# Verificar o plano
terraform plan

# Aplicar mudanças
terraform apply
```

## Backend do Terraform

Este projeto utiliza **backend local** para armazenar o estado do Terraform. 

### ⚠️ Importante: Limitações do Backend Local com GitHub Actions

O backend local é adequado para:
- **Deploy inicial único via GitHub Actions**
- **Desenvolvimento e testes locais**
- **Ambientes de demonstração**

**Limitação**: O estado não persiste entre execuções do workflow no GitHub Actions. Isso significa:
- ✅ O primeiro deploy via GitHub Actions funcionará corretamente
- ❌ Execuções subsequentes falharão pois o estado é perdido
- ✅ Para uso contínuo, migre para um backend remoto (veja abaixo)

### Uso Recomendado

**Opção 1: Deploy Único via GitHub Actions**
1. Configure as credenciais AWS nos GitHub Secrets
2. Execute o workflow uma vez para criar o bucket
3. Gerencie mudanças futuras localmente ou migre para backend remoto

**Opção 2: Desenvolvimento Local**
```bash
# Clone o repositório
git clone https://github.com/vieiracaiobruno/infra-bucket-s3.git
cd infra-bucket-s3

# Configure variáveis
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seu bucket name único

# Execute Terraform localmente
terraform init
terraform plan
terraform apply
```

### Migrando para Backend S3 (Recomendado para Produção)

Para ambientes de produção, você pode migrar para um backend S3 após a criação inicial:

1. Crie um bucket separado para o estado do Terraform
2. Adicione a configuração do backend em `provider.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "seu-bucket-terraform-state"
    key            = "s3-bucket/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
```

3. Execute `terraform init -migrate-state`

## Outputs

Após o deploy, os seguintes valores estarão disponíveis:

- `bucket_name`: Nome do bucket S3
- `bucket_arn`: ARN do bucket
- `bucket_region`: Região do bucket
- `bucket_domain_name`: Domain name do bucket