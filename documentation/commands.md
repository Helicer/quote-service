# Docker

## List images
`docker image ls`

## Build
`docker image build -t <image name>:<tag> .`

Example: `docker image build -t jro_debug:latest .`


## Tag
`docker tag <Image ID> <tag`

Example: `docker tag jro/quote-service:latest 783032674095.dkr.ecr.us-east-1.amazonaws.com/jro/quote-service:latest`


## Push
Example: `docker push 783032674095.dkr.ecr.us-east-1.amazonaws.com/jro/quote-service:latest`

## Run
`docker container run <image name>:<tag>`

## Prune
Remove un-used images

`docker image prune`




# AWS CLI commands

## Cloudformation Stacks

### List stacks
`aws cloudformation describe-stacks`


## ECS

### Create cluster

`aws ecs create-cluster \
	--cluster-name Quote-API-Cluster \`

### List clusters
`aws ecs list-clusters`

### Delete a cluster
`aws ecs delete-cluster --cluster=Cleo2`

### Describe cluster
`aws ecs describe-clusters --cluster=Quote-API-Cluster`

## VPC


### List current VPCs
`aws ec2 describe-vpcs`

### Create new VPC
https://docs.aws.amazon.com/cli/latest/reference/ec2/create-vpc.html



### List current subnets
`aws ec2 describe-subnets`


### List current network interfaces
`aws ec2 describe-network-interfaces`

### List security groups
`aws ec2 describe-security-groups`


## ECS

### Create Task

### Create a task definition
`aws ecs register-task-definition`

### Create Load Balancer

### Create Service


### Update Service to use new container
`aws ecs update-service --cluster <cluster name> --service <service name> --force-new-deployment`
