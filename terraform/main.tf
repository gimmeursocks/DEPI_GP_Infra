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
  availability_zones   = ["eu-north-1a", "eu-north-1b"]
}

module "rds" {
  source = "./modules/rds"

  db_name               = "authdb"
  db_username           = "auth_db_user"
  db_password           = "password"

  db_instance_class     = "db.t3.micro"
  db_allocated_storage  = 20

  vpc_security_group_ids = [module.networking.default_sg_id]
  subnet_ids             = module.networking.private_subnet_ids
}

