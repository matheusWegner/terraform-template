# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name    = var.domain_name
    Project = var.project_name
  }
}

# Custom Domain Association - Keycloak
resource "aws_apprunner_custom_domain_association" "keycloak" {
  domain_name = "auth.${var.domain_name}"
  service_arn = aws_apprunner_service.keycloak.arn
}

# Custom Domain Association - Backend
resource "aws_apprunner_custom_domain_association" "backend" {
  domain_name = "api.${var.domain_name}"
  service_arn = aws_apprunner_service.backend.arn
}
