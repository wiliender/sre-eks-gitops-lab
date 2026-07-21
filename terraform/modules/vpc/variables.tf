variable "aws_region" {
  description = "Região AWS utilizada para definir as zonas de disponibilidade"
  type        = string
}

variable "project_name" {
  description = "Nome base utilizado na identificação dos recursos da VPC"
  type        = string
}

variable "environment" {
  description = "Ambiente da infraestrutura"
  type        = string
}