provider "aws" {
  region = var.region
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.vpc.vpc_id
  public_subnets         = module.vpc.public_subnets
  sg_id                  = module.alb.sg_id
  ecr_repository         = module.ecr.repository_url
  blue_target_group_arn  = module.alb.blue_target_group_arn
  green_target_group_arn = module.alb.green_target_group_arn
}

module "codecommit" {
  source = "./modules/codecommit"
}

module "codebuild" {
  source             = "./modules/codebuild"
  codecommit_repo    = module.codecommit.repository
  ecr_repository     = module.ecr.repository_url
  codebuild_role_arn = module.iam.codebuild_role_arn
}

module "codedeploy" {
  source                 = "./modules/codedeploy"
  codecommit_repo        = module.codecommit.repository
  ecr_repository         = module.ecr.repository_url
  ecs_cluster            = module.ecs.cluster_name
  ecs_services           = [module.ecs.blue_service_name, module.ecs.green_service_name]
  load_balancer          = module.alb.load_balancer
  target_groups          = [module.alb.blue_target_group_arn, module.alb.green_target_group_arn]
  codedeploy_role_arn    = module.iam.codedeploy_role_arn
  listener_http_arn      = module.alb.listener_http_arn
  listener_http_green_arn = module.alb.listener_http_green_arn
}

module "iam" {
  source = "./modules/iam"
}
