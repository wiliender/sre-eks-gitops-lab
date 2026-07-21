# 1. Cria o Bucket S3 que armazenará o arquivo de estado do Terraform (terraform.tfstate)
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name # Nome do bucket definido pela variável

  tags = {
    Name      = var.state_bucket_name
    ManagedBy = "Terraform"
  }
}

# 2. Habilita o versionamento de arquivos no Bucket S3
# Permite histórico de versões e recuperação do arquivo de state caso ele seja corrompido ou sobrescrito
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Configura a criptografia padrão do Bucket S3 (Criptografia no lado do servidor)
# Garante que o arquivo de state fique criptografado em repouso usando o algoritmo AES-256
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Bloqueia todo e qualquer acesso público ao Bucket S3
# Prática fundamental de segurança em DevOps/SRE para evitar exposição de dados sensíveis contidos no state
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Cria a tabela DynamoDB utilizada para o mecanismo de State Lock (Trava de Estado)
# Evita que múltiplos membros do time ou execuções simultâneas de CI/CD alterem o estado ao mesmo tempo
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # Cobrança por demanda (sem custo fixo, ideal para labs e produção)
  hash_key     = "LockID"          # Chave primária exigida pelo Terraform para registrar a trava

  attribute {
    name = "LockID"
    type = "S" # Atributo do tipo String (S)
  }
}