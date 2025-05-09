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
}

module "rds" {
  source = "./modules/rds"

  db_name     = "authdb"
  db_username = "auth_db_user"
  db_password = "password"

  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20

  vpc_security_group_ids = [module.networking.default_sg_id]
  subnet_ids             = module.networking.private_subnet_ids
}

module "docdb" {
  source = "./modules/docdb"

  db_name     = "tododb"
  db_username = "todo_db_user"
  db_password = "password"

  vpc_security_group_ids = [module.networking.default_sg_id]
  subnet_ids             = module.networking.private_subnet_ids
}

module "ec2_jenkins" {
  source = "./modules/ec2"

  instance_type = "t3.micro"
  key_name      = "jenkins-server-ssh-key"

  vpc_security_group_ids = [module.networking.ec2_ssh_sg_id]
  subnet_id              = module.networking.public_subnet_ids[0]
}

module "eks" {
  source = "./modules/eks"

  cluster_name         = "depi-eks-cluster"
  cluster_version      = "1.29"
  subnet_ids           = module.networking.private_subnet_ids
  security_group_ids   = [module.networking.default_sg_id] # <--- This is required

  node_desired_size    = 2   # ← Correct variable names
  node_max_size        = 3
  node_min_size        = 1
  node_instance_types  = ["t3.medium"]

  node_group_name = "depi-node-group"

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}

