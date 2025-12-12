output "application_url" {
  description = "URL to access the chatroom application"
  value       = "https://${module.s3_cloudfront.cloudfront_domain_name}"
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.s3_cloudfront.cloudfront_domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket for frontend static files"
  value       = module.s3_cloudfront.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (for cache invalidation)"
  value       = module.s3_cloudfront.cloudfront_distribution_id
}

output "ecr_backend_repository_url" {
  description = "ECR repository URL for backend Docker images"
  value       = module.ecr.backend_repository_url
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs.cluster_id
}

output "redis_endpoint" {
  description = "Redis cluster endpoint"
  value       = module.elasticache.redis_endpoint
}
