variable "hostname" {
  description = "Hostname of the instance"
  default = "etcd-staging"
}

variable "count" {
  default = 3
  description = "count of the Routers"
}

variable "key_name" {
  default = "Gengo-DevOps"
  description = "Access Key name"
}

variable "instance_type" {
  default = "t2.medium"
  description = "etcd instance type"
}

variable "subnet_ids" {
  type = "list"
  description = "Multizone subnet IDs. All subnets must be in the same VPC."
}

variable "security_group_ids" {
  description = "router security groups"
  default = []
}

variable "route53_zone_id" {
  type = "string"
  description = "Route53 Hosted zone id"
}

variable "cookbooks_dir" {
  type = "string"
  description = "Chef cookbooks directory"
  default = "/srv/devops-tools/daidokoro"
}
