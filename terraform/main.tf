module "ecr_repos" {
  source = "./modules/ecr"
  for_each = {
    "todo-app-api-service" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    }
    "todo-app-frontend" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    }
    "todo-app-auth-service" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    }
    "todo-app-todo-service" = {
      image_tag_mutability = "MUTABLE"
      scan_on_push         = true
    }
  }

  name                 = each.key
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = each.value.scan_on_push
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]
  cluster_name         = "depi-eks-cluster"
}

module "rds" {
  source = "./modules/rds"

  db_name     = "authdb"
  db_username = "auth_db_user"
  db_password = var.db_password

  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20

  vpc_security_group_ids = [module.networking.default_sg_id]
  subnet_ids             = module.networking.private_subnet_ids
}

module "docdb" {
  source = "./modules/docdb"

  db_name     = "tododb"
  db_username = "todo_db_user"
  db_password = var.docdb_password

  vpc_security_group_ids = [module.networking.default_sg_id]
  subnet_ids             = module.networking.private_subnet_ids
}

module "iam" {
  source = "./modules/security/iam"

  cluster_name       = "depi-eks-cluster"
  cluster_depends_on = module.eks.cluster_id
}

module "jenkins_master" {
  source = "./modules/ec2"

  instance_type        = "t3.micro"
  key_name             = "jenkins-server-ssh-key"
  user_data            = file("${path.module}/user_data/jenkins_server.sh")
  iam_instance_profile = module.iam.jenkins_profile

  vpc_security_group_ids = [module.networking.ec2_ssh_sg_id, module.networking.jenkins_sg_id]
  subnet_id              = module.networking.public_subnet_ids[0]

  tags = {
    Name = "jenkins-master"
    Role = "jenkins-master"
  }
}

module "jenkins_agent" {
  source = "./modules/ec2"

  instance_type        = "t3.medium"
  key_name             = "jenkins-server-ssh-key"
  user_data            = file("${path.module}/user_data/jenkins_server.sh")
  iam_instance_profile = module.iam.jenkins_profile

  vpc_security_group_ids = [module.networking.ec2_ssh_sg_id, module.networking.jenkins_sg_id]
  subnet_id              = module.networking.public_subnet_ids[0]

  tags = {
    Name = "jenkins-agent"
    Role = "jenkins-agent"
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "depi-eks-cluster"
  cluster_version    = "1.32"
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.default_sg_id]

  key_name = "eks-ssh-key"

  node_desired_size   = 1
  node_max_size       = 3
  node_min_size       = 1
  node_instance_types = ["t3.medium"]

  node_group_name         = "depi-node-group"
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
}

module "alb_ingress" {
  source       = "./modules/alb_ingress"
  cluster_name = module.eks.cluster_name
  region       = "eu-central-1"
  vpc_id       = module.networking.vpc_id
  alb_role_arn = module.iam.alb_ingress_role_arn

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.eks]
}
