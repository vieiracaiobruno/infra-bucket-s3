# infra-bucket-s3

Infraestrutura Terraform para criação de bucket S3 na AWS.

## Descrição

Este projeto provisiona um bucket S3 na AWS chamado `bolsa-de-valores` com as seguintes características:

- **Criptografia**: AES256 habilitada por padrão
- **Versionamento**: Habilitado (configurável via variável)
- **Acesso Público**: Bloqueado em todos os níveis
- **Tags**: Ambiente, nome e gerenciamento via Terraform

## Requisitos

- Terraform >= 1.0
- AWS CLI configurado ou credenciais via GitHub Secrets
- Acesso IAM à AWS com permissões para criar buckets S3

## Configuração

### Variáveis

As variáveis podem ser personalizadas em `variables.tf`:

- `bucket_name`: Nome do bucket (padrão: "bolsa-de-valores")
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

Este projeto utiliza **backend local** para armazenar o estado do Terraform. Isso permite que o Terraform inicialize sem depender de um bucket S3 pré-existente, resolvendo o problema de "chicken-and-egg".

### Migrando para Backend S3 (Opcional)

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
