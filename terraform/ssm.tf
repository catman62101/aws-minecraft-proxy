resource "aws_ssm_parameter" "admin_public_key" {
  name  = "/mc_server_proxy/admin_public_key"
  type  = "String"
  value = var.admin_public_key

  tags = {
    Name = "MinecraftServerProxy"
  }
}

resource "aws_ssm_parameter" "tunnel_public_key" {
  name  = "/mc_server_proxy/tunnel_public_key"
  type  = "String"
  value = var.tunnel_public_key

  tags = {
    Name = "MinecraftServerProxy"
  }
}

