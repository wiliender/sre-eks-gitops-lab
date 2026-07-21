output "aws_region" {
  description = "Região AWS configurada"
  value       = var.aws_region
}

output "project_name" {
  description = "Nome do projeto"
  value       = var.project_name
}

output "environment" {
  description = "Ambiente configurado"
  value       = var.environment
}

output "cluster_name" {
  description = "Nome planejado para o cluster EKS"
  value       = var.cluster_name
}

output "name_prefix" {
  description = "Prefixo utilizado na nomenclatura dos recursos"
  value       = local.name_prefix
}