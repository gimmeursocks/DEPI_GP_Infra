provider "kubernetes" {
  alias                  = "eks_cluster"
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      aws_eks_cluster.this.name
    ]
  }
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.eks_node_group_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  remote_access {
    ec2_ssh_key = var.key_name
  }

  instance_types = var.node_instance_types

  tags = var.tags
}

data "aws_caller_identity" "current" {}

resource "kubernetes_config_map" "aws_auth" {
  provider = kubernetes.eks_cluster
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.eks_node_group_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecr_jenkins_permission"
        username = "jenkins"
        groups   = ["system:masters"]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/gimmeursocks"
        username = "gimmeursocks"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/hafez"
        username = "hafez"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"
        username = "terraform"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [aws_eks_node_group.this]
}
