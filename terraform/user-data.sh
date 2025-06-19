#!/bin/bash

assert_public_key_found() {
  if [ -z $1 ]; then
    echo "SSH Public key not found, exiting..."
    exit 1
  fi
}

ADMIN_USER=admin
ADMIN_SSH_PUBLIC_KEY=$(aws ssm get-parameter \
  --name "/mc_server_proxy/admin_public_key" \
  --query "Parameter.Value")
assert_public_key_found $ADMIN_SSH_PUBLIC_KEY

TUNNEL_USER=tunnel
TUNNEL_SSH_PUBLIC_KEY=$(aws ssm get-parameter \
  --name "/mc_server_proxy/tunnel_public_key" \
  --query "Parameter.Value")
assert_public_key_found $TUNNEL_SSH_PUBLIC_KEY

add_user_with_authorized_key() {
  username=$1
  public_key=$2
  useradd -m -s /bin/bash $username
  mkdir -p /home/$username/.ssh
  cat $public_key > /home/$username/.ssh/authorized_keys
  chmod -R 700 /home/$username/.ssh
  chown -R $username:$username /home/$username/.ssh
}

add_user_with_authorized_key $ADMIN_USER $ADMIN_SSH_PUBLIC_KEY
add_user_with_authorized_key $TUNNEL_USER $TUNNEL_SSH_PUBLIC_KEY

# give admin user sudo privileges
echo "$ADMIN_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$ADMIN_USER"

