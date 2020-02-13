locals {
  public_subnet_block  = "${var.cidr_base}.0.0/17"
  private_subnet_block = "${var.cidr_base}.128.0/17"
}

resource "aws_subnet" "public" {
  count                   = "${local.region-to-az-count-map[var.region]}"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${cidrsubnet(local.public_subnet_block, ceil(log(local.region-to-az-count-map[var.region] * 2, 2)), count.index)}"
  availability_zone       = "${var.region}${local.num-to-az-letter-map[count.index]}"
  map_public_ip_on_launch = true

  tags = "${merge(
    var.public_subnet_tags,
    var.tags,
    map(
      "Name", "public-${var.name}-${var.region}${local.num-to-az-letter-map[count.index]}",
      "Environment", "${var.environment}",
      "AvailabilityZone", "${var.region}${local.num-to-az-letter-map[count.index]}"
    )
  )}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name   = "public-${var.name}"
    Region = "${var.region}"
  }
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.default.id}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.public"]
}

resource "aws_route_table_association" "public" {
  count          = "${local.region-to-az-count-map[var.region]}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  depends_on     = ["aws_subnet.public", "aws_route_table.public"]
}

resource "aws_eip" "public" {
  count      = "${local.region-to-az-count-map[var.region]}"
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name             = "public-${var.name}-${var.region}${local.num-to-az-letter-map[count.index]}"
    Environment      = "${var.environment}"
    AvailabilityZone = "${var.region}${local.num-to-az-letter-map[count.index]}"
  }
}

resource "aws_nat_gateway" "public" {
  count         = "${local.region-to-az-count-map[var.region]}"
  allocation_id = "${element(aws_eip.public.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_subnet.public"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name             = "public-${var.name}-${var.region}${local.num-to-az-letter-map[count.index]}"
    Environment      = "${var.environment}"
    AvailabilityZone = "${var.region}${local.num-to-az-letter-map[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count             = "${local.region-to-az-count-map[var.region]}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${cidrsubnet(local.private_subnet_block, ceil(log(local.region-to-az-count-map[var.region] * 2, 2)), count.index)}"
  availability_zone = "${var.region}${local.num-to-az-letter-map[count.index]}"

  tags = "${merge(
    var.private_subnet_tags,
    var.tags,
    map(
      "Name", "private-${var.name}-${var.region}${local.num-to-az-letter-map[count.index]}",
      "Environment", "${var.environment}",
      "AvailabilityZone", "${var.region}${local.num-to-az-letter-map[count.index]}"
    )
  )}"
}

resource "aws_route_table" "private" {
  count  = "${local.region-to-az-count-map[var.region]}"
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name             = "private-${var.name}-${var.region}${local.num-to-az-letter-map[count.index]}"
    Environment      = "${var.environment}"
    AvailabilityZone = "${var.region}${local.num-to-az-letter-map[count.index]}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${local.region-to-az-count-map[var.region]}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}

resource "aws_route" "private" {
  count                  = "${local.region-to-az-count-map[var.region]}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.public.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}
