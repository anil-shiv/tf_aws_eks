resource "aws_vpc" "shiv_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "shivaanta-eks-demo-node",
    "kubernetes.io/cluster/${var.CLUSTER_NAME}" = "shared",
  })
}

resource "aws_subnet" "shiv_vpc_public_subnet" {
  count = var.NUMBER_OF_PUBLIC_SUBNET

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.shiv_vpc.id

  tags = tomap({
    "Name"                                      = "shivaanta-eks-demo-node",
    "kubernetes.io/cluster/${var.CLUSTER_NAME}" = "shared",
  })
}

resource "aws_internet_gateway" "shiv_vpc_ig" {
  vpc_id = aws_vpc.shiv_vpc.id

  tags = {
    Name = "shivaanta-eks-demo"
  }
}

resource "aws_route_table" "shiv_vpc_rt" {
  vpc_id = aws_vpc.shiv_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shiv_vpc_ig.id
  }
}

resource "aws_route_table_association" "shiv_vpc_rt_association" {
  count = var.NUMBER_OF_PUBLIC_SUBNET

  subnet_id      = aws_subnet.shiv_vpc_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.shiv_vpc_rt.id
}