# Variável para definir o nome do Bucket S3 que guardará o estado do Terraform
# Não possui valor default pois o nome do bucket precisa ser globalmente único na AWS
variable "state_bucket_name" {
  description = "Nome do bucket S3 para armazenar o state"
  type        = string
}

# Variável para definir o nome da tabela DynamoDB usada para o State Lock (controle de concorrência)
variable "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB para lock"
  type        = string
  default     = "terraform-lock"
}

# Variável para definir a região da AWS onde o Bucket e a tabela serão provisionados
variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}