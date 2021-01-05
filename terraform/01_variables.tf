#############################
# VARIABLES
#############################


# Borrowed heavily from https://github.com/bradford-hamilton/terraform-ecs-fargate/tree/master/terraform

#-----------------------------
# AWS fundamentals
#-----------------------------


variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

# AWS Availability Zones
variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "3"
}


#-----------------------------
# App-specific settings
#-----------------------------

variable "app_id" {
  description = "Name of app/environment to use in AWS naming and tagging"
  default     = "Quote-API"
}

//variable "app_image" {
//  description = "Docker image to run in the ECS cluster"
////  default     = "783032674095.dkr.ecr.us-east-1.amazonaws.com/jro/quote-service:latest"
//  default     = aws_ecr_repository.ecr.repository_url
//}

variable "app_port" {
  description = "Port exposed by the app's docker image"
  default     = 8080
}

variable "app_count" {
  description = "Number of app instances (docker containers) to run"
  default     = 3
}

variable "health_check_path" {
  description = "Application URL which indicates health"
  # Using Spring Boot Actuator
  default = "/actuator/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}


