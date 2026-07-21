# Chama o módulo oficial da comunidade/AWS no Terraform Registry para criação e gestão do EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" # Trava na versão major 21.x (permite correções de bugs e atualizações minor seguras)

  name               = var.cluster_name       # Nome definido para o cluster Kubernetes
  kubernetes_version = var.kubernetes_version # Versão do Kubernetes a ser instalada no Control Plane

  vpc_id     = var.vpc_id     # ID da rede VPC onde o cluster será ancorado (recebido do módulo VPC)
  subnet_ids = var.subnet_ids # Lista de subnets privadas onde os Worker Nodes serão provisionados

  # Permite acesso à API do Kubernetes (kubectl) via internet pública (ideal para labs/testes)
  endpoint_public_access = true

  # Concede automaticamente permissão de admin no Kubernetes para a identidade AWS que rodou o Terraform
  enable_cluster_creator_admin_permissions = true

  # Define os grupos de instâncias (Worker Nodes) gerenciados diretamente pela AWS (EKS Managed Node Groups)
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"] # Tipo de instância EC2 econômica, ótima para estudos/labs

      # Configuração do Auto Scaling Group (ASG)
      min_size     = 1 # Mínimo de 1 máquina ativa
      max_size     = 2 # Pode escalar para até 2 máquinas sob demanda
      desired_size = 1 # Tamanho inicial/desejado do grupo de máquinas
    }
  }

  # Tags padrão injetadas no cluster e em todas as instâncias e recursos associados ao EKS
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}