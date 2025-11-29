output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "keycloak_url" {
  description = "Keycloak service URL"
  value       = aws_apprunner_service.keycloak.service_url
}

output "backend_url" {
  description = "Backend API URL"
  value       = aws_apprunner_service.backend.service_url
}

output "ecr_backend_repository" {
  description = "ECR repository URL for backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_keycloak_repository" {
  description = "ECR repository URL for keycloak"
  value       = aws_ecr_repository.keycloak.repository_url
}

output "apprunner_role_arn" {
  description = "IAM role ARN for App Runner ECR access"
  value       = aws_iam_role.apprunner_ecr_access.arn
}

output "route53_nameservers" {
  description = "Route 53 nameservers - Configure these in Squarespace"
  value       = aws_route53_zone.main.name_servers
}

output "keycloak_custom_domain" {
  description = "Keycloak custom domain"
  value       = "https://auth.${var.domain_name}"
}

output "backend_custom_domain" {
  description = "Backend custom domain"
  value       = "https://api.${var.domain_name}"
}
