resource "aws_security_group" "rs_sg" {
  name   = "${var.namespace_name}-sg"
  vpc_id = var.vpc_id
  description = "Redshift Serverless SG"
}

# allow ingress from EKS SG(s) to default postgres port 5439
resource "aws_security_group_rule" "allow_from_eks" {
  count = length(var.ingress_from_security_group_ids)
  type = "ingress"
  from_port = 5439
  to_port = 5439
  protocol = "tcp"
  security_group_id = aws_security_group.rs_sg.id
  source_security_group_id = var.ingress_from_security_group_ids[count.index]
}