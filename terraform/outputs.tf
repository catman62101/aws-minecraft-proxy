output "mc_server_proxy_ip" {
  description = "public ip of the minecraft server proxy"
  value       = aws_instance.mc_server_proxy.public_ip
}

