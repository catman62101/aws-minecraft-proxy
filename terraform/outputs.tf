output "mc_server_proxy_ip" {
  description = "public ip of the minecraft server proxy"
  value       = module.aws_instance.public_ip
}

