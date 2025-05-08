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
