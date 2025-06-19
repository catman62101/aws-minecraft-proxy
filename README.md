# aws-minecraft-proxy

## Step 1 : Create the local Minecraft server

### Install Ubuntu server

### Optionally create `admin` user

```sh
sudo useradd -m admin
echo "admin ALL=(ALL) NOPASSWD: ALL" | sudo dd status=none of=/etc/sudoers.d/admin
```

### Copy SSH public key into `admin`'s `authorized_keys` file

todo
```sh 
cat PUBLIC_KEY >> /home/admin/.ssh/authorized_keys
```

### Create Minecraft server

```sh
cd ansible
ansible-playbooks create_mc_server.yml
ansible-playbooks start_mc_server.yml
```

## Step 2 : Create an AWS account and get an API key ??

## Step 3 : Create the proxy server and related infrastructure on AWS

```sh
terraform apply
```

## Step 4 : Create the reverse SSH tunnel

```sh
cd ansible
ansible-playbooks create_tunnel.yml  
ansible-playbooks start_tunnel.yml
```
