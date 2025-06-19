resource "aws_ssm_parameter" "admin_public_key" {
  name  = "/mc_server_proxy/admin_public_key"
  type  = "String"
  value = vars.admin_public_key

  tags = {
    Name = "MinecraftServerProxy"
  }
}

resource "aws_ssm_parameter" "tunnel_public_key" {
  name  = "/mc_server_proxy/tunnel_public_key"
  type  = "String"
  value = vars.tunnel_public_key

  tags = {
    Name = "MinecraftServerProxy"
  }
}

