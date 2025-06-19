resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MinecraftServerProxy"
  }
}

# Create 3 subnets, each in a different availability zone (AZ). In the event
# that one AZ fails, we can just move the proxy server to another subnet.
resource "aws_subnet" "subnet" {
  count  = 3
  vpc_id = aws_vpc.main.id

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet("10.0.0.0/16", 4, count.index)

  tags = {
    Name = "MinecraftServerProxy"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count          = 3
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.table.id
}

resource "aws_security_group" "mc_server_proxy_sg" {
  name        = "mc_server_proxy_sg"
  description = "Allow SSH and Java Minecraft server connections"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.mc_server_proxy_sg.id
  # Should probably change this to whatever IP your Minecraft server host will
  # initiate the reverse SSH tunnel connection. (TODO)
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_java_mc" {
  security_group_id = aws_security_group.mc_server_proxy_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25565
  to_port           = 25565
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.mc_server_proxy_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
}

