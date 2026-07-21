# Bloco de valores locais (escopo do módulo) para reutilização de padrões no módulo VPC
locals {
  # Padroniza a criação do prefixo de nome agrupando projeto e ambiente
  name_prefix = "${var.project_name}-${var.environment}"

  # Define o mapa de tags padrão que será injetado em todos os recursos da VPC
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Chama o módulo oficial da AWS para criação da VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0" # Trava a versão major em 6.x garantindo estabilidade e atualizações de segurança

  name = local.name_prefix # Aplica o nome base padronizado na VPC e recursos associados
  cidr = "10.0.0.0/16"     # Bloco principal de IPs da VPC (até 65.536 endereços)

  # Distribui a rede entre duas Zonas de Disponibilidade da região configurada (ex: us-east-1a e us-east-1b)
  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  # Subnets públicas (usadas para borda/Load Balancers públicos)
  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  # Subnets privadas (onde rodarão os worker nodes do EKS e aplicações)
  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  # Desabilita NAT Gateway para economia de custos no ambiente de laboratório
  enable_nat_gateway = false

  # Suporte a resolução DNS dentro da VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags # Injeta as tags globais do módulo

  # Tag essencial para o AWS Load Balancer Controller identificar onde provisionar Load Balancers PÚBLICOS do EKS
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  # Tag essencial para o AWS Load Balancer Controller identificar onde provisionar Load Balancers INTERNOS do EKS
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}