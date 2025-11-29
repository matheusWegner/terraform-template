output "frontend_url" {
  description = "Frontend URL"
  value       = aws_apprunner_service.frontend.service_url
}

output "ecr_frontend_repository" {
  description = "ECR repository URL for frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "apprunner_role_arn" {
  description = "IAM role ARN for App Runner ECR access"
  value       = aws_iam_role.apprunner_ecr_access.arn
}
