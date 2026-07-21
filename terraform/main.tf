# Bloco de valores locais (variáveis internas reaproveitáveis que não dependem de entrada direta do usuário)
locals {
  # Padroniza a criação de um prefixo de nome agrupando o nome do projeto e o ambiente (ex: "sre-eks-gitops-lab-dev")
  name_prefix = "${var.project_name}-${var.environment}"

  # Define um mapa de tags padrão para ser reutilizado nos recursos provisionados
  common_tags = {
    Project     = var.project_name # Identifica a qual projeto o recurso pertence
    Environment = var.environment  # Identifica o ambiente (ex: dev, staging, prod)
    ManagedBy   = "Terraform"      # Indica que o recurso é gerenciado via Infraestrutura como Código (IaC)
  }
}

# Chama e instancia o módulo customizado de rede (VPC)
module "vpc" {
  # Define o caminho relativo do código-fonte onde os recursos da VPC estão declarados
  source = "./modules/vpc"

  # Passa a região da AWS configurada no projeto raiz para dentro do módulo
  aws_region = var.aws_region

  # Repassa os metadados para padronização de nomenclatura e tags dentro do módulo
  project_name = var.project_name
  environment  = var.environment
}