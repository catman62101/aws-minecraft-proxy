resource "aws_instance" "minecraft-server-proxy" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "MinecraftServerProxy"
  }
}

