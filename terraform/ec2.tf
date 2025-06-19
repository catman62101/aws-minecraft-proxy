resource "aws_iam_role" "ssm_read_param" {
  name = "SsmReadParam"
  path = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ssm_read_param_policy" {
  name = "ssm_read_param_policy"
  role = aws_iam_role.ssm_read_param.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ssm:GetParameter"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_read_param_profile" {
  name = "ssm_read_param_profile"
  role = aws_iam_role.ssm_read_param.name
}

resource "aws_instance" "mc_server_proxy" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  user_data                   = file("${path.module}/user-data.sh")
  subnet_id                   = aws_subnet.subnet[var.mc_server_proxy_subnet].id
  vpc_security_group_ids      = [aws_security_group.mc_server_proxy_sg.id]
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.ssm_read_param_profile.name

  tags = {
    Name = "MinecraftServerProxy"
  }

  depends_on = [
    aws_ssm_parameter.admin_public_key,
    aws_ssm_parameter.tunnel_public_key,
  ]
}

