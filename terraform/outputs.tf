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

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}