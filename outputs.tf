output "vpc_id" {
  value = aws_vpc.default.id
  description ="the AWS ID of the VPC"
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
  description ="the AWS IDs of all private subnets of the VPC"
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
  description ="the AWS IDs of all public subnets of the VPC"
}

output "cidr_block" {
  value = aws_vpc.default.cidr_block
  description = "the full cidr block notation for the VPC"
}
