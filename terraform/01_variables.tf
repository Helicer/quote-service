
# Borrowed heavily from https://github.com/bradford-hamilton/terraform-ecs-fargate/tree/master/terraform

#-----------------------------
# AWS fundamentals
#-----------------------------


variable "aws_region" {
  description = "The AWS"
  default     = "us-east-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}


#-----------------------------
# App-specific settings
#-----------------------------

variable "app_id" {
  description = "Name of app/environment to use in AWS naming"
  default = "Coco-API"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "783032674095.dkr.ecr.us-east-1.amazonaws.com/jro/quote-service:0.1"
}

variable "app_port" {
  description = "Port exposed by the app's docker image"
  default     = 8080
}

variable "app_count" {
  description = "Number of app instances (docker containers) to run"
  default     = 2
}

variable "health_check_path" {
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


