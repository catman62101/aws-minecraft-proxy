resource "aws_instance" "mc_server_proxy" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  user_data                   = file("${path.module}/user-data.sh")
  subnet_id                   = aws_subnet.subnet[var.mc_server_proxy_subnet].id
  vpc_security_group_ids      = [aws_security_group.mc_server_proxy_sg.id]
  associate_public_ip_address = "true"

  tags = {
    Name = "MinecraftServerProxy"
  }

  depends_on = [
    aws_ssm_parameter.admin_public_key,
    aws_ssm_parameter.tunnel_public_key,
  ]
}

