# Cluster IAM role
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "eks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# Node group role
resource "aws_iam_role" "eks_node" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# IAM Role for eks addons
data "aws_iam_policy_document" "eks_addons_assume_role_policy" {
  statement {
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    effect = "Allow"

    condition {
      test = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values = [ "system:serviceaccount:kube-system:ebs-csi-controller-sa" ]
    }

    principals {
      identifiers = [ aws_iam_openid_connect_provider.eks.arn ]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_addons" {
  name = "${var.cluster_name}-addons-role"
  assume_role_policy = data.aws_iam_policy_document.eks_addons_assume_role_policy.json
}

resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name = "${var.cluster_name}-ebs-csi-driver-policy"
  description = ("IAM policy for EBS CSI Driver")
  policy = file("${path.module}/ebs-csi-driver-policy.json")
}

resource "aws_iam_policy_attachment" "ebs_csi_driver_attach" {
  name       = "${var.cluster_name}-ebs-csi-driver-attach"
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
  roles      = [aws_iam_role.eks_addons.name]
  
}