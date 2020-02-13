variable "name" {
  description = "the name of the VPC"
}

variable "region" {
  description = "the region the VPC resides in"
}

variable "environment" {
  description = "the environment the VPC is in (qa, trial, prod, etc.)"
}

variable "cidr_base" {
  description = "the network portion of the cidr block for the VPC"
}

variable "tags" {
  type        = "map"
  description = "additional tags to be added to each resource"
  default     = {}
}

variable "private_subnet_tags" {
  type        = "map"
  description = "additional private tags to be added to private subnets"
  default     = {}
}

variable "public_subnet_tags" {
  type        = "map"
  description = "additional public tags to be added to public subnets"
  default     = {}
}
