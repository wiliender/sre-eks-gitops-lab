# Variável para definir a região da AWS onde os recursos serão criados
variable "aws_region" {
  description = "Região AWS utilizada pelo projeto"
  type        = string
  default     = "us-east-1"

  # Validação: Garante via Expressão Regular (Regex) que o valor informado segue o padrão da AWS (ex: us-east-1, sa-east-1)
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "A região AWS deve possuir um formato válido, como us-east-1."
  }
}

# Variável com o nome base do projeto (usado para compor nomes e tags de recursos)
variable "project_name" {
  description = "Nome utilizado na identificação dos recursos"
  type        = string
  default     = "sre-eks-gitops-lab"

  # Validação: Exige que o nome do projeto tenha no mínimo 3 caracteres para evitar nomes curtos demais ou vazios
  validation {
    condition     = length(var.project_name) >= 3
    error_message = "O nome do projeto deve possuir pelo menos três caracteres."
  }
}

# Variável para definir o ambiente de execução (dev, staging ou prod)
variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
  default     = "dev"

  # Validação: Restringe a entrada aceitando APENAS um dos três valores permitidos na lista
  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "O ambiente deve ser dev, staging ou prod."
  }
}

# Variável com o nome do cluster Kubernetes (Amazon EKS)
variable "cluster_name" {
  description = "Nome do cluster Amazon EKS"
  type        = string
  default     = "sre-eks-gitops-dev"
}

# Variável para fixar a versão do Kubernetes utilizada no cluster
variable "kubernetes_version" {
  description = "Versão do Kubernetes utilizada pelo Amazon EKS"
  type        = string
  default     = "1.32"
}