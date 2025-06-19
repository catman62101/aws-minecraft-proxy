variable "tunnel_public_key" {
  type        = string
  description = "SSH Public Key for Minecraft server's reverse SSH tunnel"
}

variable "admin_public_key" {
  type        = string
  description = "SSH Public Key for admin tasks"
}

# Use the first subnet defined by default, override to 1 or 2 if the
# availability zone the first subnet is in fails.
variable "mc_server_proxy_subnet" {
  type    = number
  default = 0
}

