# Amazon Elastic Container Registry (ECR)

resource "aws_ecr_repository" "ecr" {
  # The name must start with a letter and can only contain lowercase letters, numbers, hyphens (-), underscores (_), and forward slashes (/).
  name            = lower(var.app_id)

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.app_id}-ECR"
  }

  provisioner "local-exec" {
    // TODO: Refactor tag as variable
    command = "docker tag jro/quote-service:latest ${aws_ecr_repository.ecr.repository_url}:latest && docker push ${aws_ecr_repository.ecr.repository_url}:latest"
  }

}

output "aws_ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}