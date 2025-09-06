resource "aws_kms_key" "this" {
  description = "KMS key for ${var.name}"
  enable_key_rotation = true
  tags = { Name = var.name }
}

resource "aws_kms_alias" "this" {
  name = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

output "kms_key_id" {
  value = aws_kms_key.this.id
}
output "kms_key_arn" {
  value = aws_kms_key.this.arn
}
