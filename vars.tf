
variable "aws_region" {
  default = "eu-north-1"
  description = "Determines where to create the cluster"
}

variable "ami_id" {
  type    = string
  default = "ami-064087b8d355e9051"
  description = "AWS EC2 image to use"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  description = "A list of availability zones"
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "Private subnets"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "Public subnets"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
  description = "ssh username"
}

# https://developer.hashicorp.com/consul/tutorials/production-deploy/reference-architecture#hardware-sizing-for-consul-servers
# https://developer.hashicorp.com/nomad/docs/install/production/requirements
variable "server_instance_type" {
  type    = string
  default = "t3.small"
  description = "server instance size"
}

variable "server_node_count" {
  type    = number
  default = 3
  description = "Number of server nodes in the cluster"
}

variable "client_instance_type" {
  type    = string
  default = "t3.micro"
  description = "client instance size"
}

variable "client_node_count" {
  type    = number
  default = 1
  description = "Number of client nodes in the cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
  description = "Network range"
}
