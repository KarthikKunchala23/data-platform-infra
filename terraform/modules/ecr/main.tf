resource "aws_ecr_repository" "this" {
  name = var.name
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = var.kms_key_id == "" ? "AES256" : "KMS"
    kms_key = var.kms_key_id == "" ? null : var.kms_key_id
  }
  tags = { Name = var.name }
}

output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}
output "repository_arn" {
  value = aws_ecr_repository.this.arn
}
