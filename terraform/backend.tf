# Bloco de configuração do Terraform para armazenamento do estado remoto
terraform {
  # Define o S3 da AWS como o provedor de backend onde o arquivo .tfstate será armazenado
  backend "s3" {
    bucket         = "sre-eks-gitops-lab-wiliender-2026-tfstate" # Nome do bucket S3 único criado no bootstrap
    key            = "dev/terraform.tfstate"                     # Caminho/nome do arquivo de estado dentro do bucket
    region         = "us-east-1"                                 # Região AWS onde o bucket S3 está localizado
    encrypt        = true                                        # Garante a criptografia server-side (SSE-S3) do arquivo de estado
    dynamodb_table = "terraform-lock"                            # Tabela DynamoDB para controle de trava (State Lock) contra concorrência
  }
}