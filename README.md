# Terraform: AWS VPC

This provides the `vpc` terraform module for the AWS provider.

This provisions a new VPC using a `/16` network space, with:
 - An Elastic IP, route table, and NAT gateway
 - 3 private subnets
 - 3 public subnets

## Usage
In your `.tf` file, import the module:

```terraform
module "vpc" {
  source  = "app.terraform.io/auditboard/vpc/aws"
  version = "1.1.1"

  name        = "${local.name}"
  region      = "${local.region}"                     # e.g. us-west-2
  environment = "${local.environment}"                # e.g. prod, trial, qa, etc...
  cidr_base   = "${var.cidr_base[local.environment]}" # e.g. "10.20"
}
```
