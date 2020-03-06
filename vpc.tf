resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_base}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
  )
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = var.name
    Region      = var.region
    Environment = var.environment
  }
}
