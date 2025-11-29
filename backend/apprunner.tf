# App Runner - Keycloak
resource "aws_apprunner_service" "keycloak" {
  service_name = "${var.project_name}-keycloak"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.keycloak.repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "8080"

        runtime_environment_variables = {
          KC_DB               = "postgres"
          KC_DB_URL           = "jdbc:postgresql://${aws_db_instance.postgres.endpoint}/keycloak_app"
          KC_DB_USERNAME      = var.db_username
          KC_DB_PASSWORD      = var.db_password
          KC_HOSTNAME_STRICT  = "false"
          KC_HTTP_ENABLED     = "true"
          KC_PROXY            = "edge"
          KC_PROXY_HEADERS    = "xforwarded"
          KEYCLOAK_ADMIN      = "admin"
          KEYCLOAK_ADMIN_PASSWORD = var.keycloak_admin_password
        }
      }
    }
  }

  instance_configuration {
    cpu    = "2048"
    memory = "4096"
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.main.arn
    }
  }

  health_check_configuration {
    protocol            = "TCP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }

  tags = {
    Name = "${var.project_name}-keycloak"
  }
}

# App Runner - Backend
resource "aws_apprunner_service" "backend" {
  service_name = "${var.project_name}-backend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = "${aws_ecr_repository.backend.repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "8080"

        runtime_environment_variables = {
          SPRING_PROFILES_ACTIVE = "prod"
          DB_HOST                = split(":", aws_db_instance.postgres.endpoint)[0]
          DB_PORT                = "5432"
          DB_NAME                = "keycloak_app"
          DB_USERNAME            = var.db_username
          DB_PASSWORD            = var.db_password
          KEYCLOAK_ISSUER_URI    = "https://${aws_apprunner_service.keycloak.service_url}/realms/app"
          KEYCLOAK_JWK_SET_URI   = "https://${aws_apprunner_service.keycloak.service_url}/realms/app/protocol/openid-connect/certs"
        }
      }
    }
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.main.arn
    }
  }

  health_check_configuration {
    protocol            = "TCP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 5
  }

  tags = {
    Name = "${var.project_name}-backend"
  }

  depends_on = [aws_apprunner_service.keycloak]
}
