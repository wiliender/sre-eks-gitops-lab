# Variável para definir o nome do cluster Amazon EKS
variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

# Variável para especificar a versão do Kubernetes (ex: "1.32", "1.35")
variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
}

# Variável para receber o ID da VPC onde o EKS e os Security Groups serão provisionados
variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

# Variável para passar a lista de subnets PRIVADAS onde os worker nodes do EKS serão executados
variable "subnet_ids" {
  description = "IDs das subnets privadas utilizadas pelo EKS"
  type        = list(string) # Tipo Lista de Strings (ex: ["subnet-xxx", "subnet-yyy"])
}

# Variável para definir o ambiente da infraestrutura (ex: dev, staging, prod)
variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
}