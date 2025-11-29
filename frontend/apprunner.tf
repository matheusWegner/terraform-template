# App Runner - Frontend
resource "aws_apprunner_service" "frontend" {
  service_name = "${var.project_name}-frontend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.frontend.repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "8080"

        runtime_environment_variables = {
          NODE_ENV            = "production"
          API_URL             = "https://fbf2vdjpf3.us-east-1.awsapprunner.com"
          KEYCLOAK_URL        = "https://k4q2xqmsnc.us-east-1.awsapprunner.com"
          KEYCLOAK_REALM      = "app"
          KEYCLOAK_CLIENT_ID  = "frontend-spa"
        }
      }
    }
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  health_check_configuration {
    protocol = "HTTP"
    path     = "/healthz"
  }

  tags = {
    Name = "${var.project_name}-frontend"
  }
}
