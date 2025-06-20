# aws-minecraft-proxy

## Step 1 : Create the local Minecraft server

### Install Ubuntu server

### Create admin user (optional)

```sh
sudo useradd -m admin
echo "admin ALL=(ALL) NOPASSWD: ALL" | sudo dd status=none of=/etc/sudoers.d/admin
```

## Step 2 : Create an AWS account and get an API key ??

## Step 3 : Create the proxy server and related infrastructure on AWS

## Step 4 : Create the reverse SSH tunnel

NOTE: edit sshd config to allow binding to non-loopback addresses in the proxy server (sudo sed -i -E 's/#(GatewayPorts) no/\1 yes/g')
