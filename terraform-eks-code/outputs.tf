# Outputs
output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}