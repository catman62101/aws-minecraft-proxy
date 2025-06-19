resource "aws_ssm_parameter" "admin_public_key" {
 name = "admin_public_key"
 type = "String"
 value = vars.admin_public_key
}

resource "aws_ssm_parameter" "tunnel_public_key" {
 name = "tunnel_public_key"
 type = "String"
 value = vars.tunnel_public_key
}

