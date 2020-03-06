output "vpc_id" {
  value = aws_vpc.default.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private.*.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public.*.id]
}

output "cidr_block" {
  value = aws_vpc.default.cidr_block
}
