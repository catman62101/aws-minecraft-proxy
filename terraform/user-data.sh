#!/bin/bash

# Echo commands for debugging purposes; check /var/log/cloud-init-output
set -x

assert_public_key_found() {
  if [ -z $1 ]; then
    echo "SSH Public key not found, exiting..."
    exit 1
  fi
}

get_ssh_public_key() {
  user=$1
  aws_region=$2
  aws ssm get-parameter \
    --name "/mc_server_proxy/${user}_public_key" \
    --query "Parameter.Value" \
    --output "text" \
    --region $aws_region
}

add_user_with_authorized_key() {
  username=$1
  public_key=$2
  echo "Adding public key `$public_key` for user `$username`..."
  useradd -m -s /bin/bash $username
  mkdir -p /home/$username/.ssh
  echo $public_key > /home/$username/.ssh/authorized_keys
  chmod -R 700 /home/$username/.ssh
  chown -R $username:$username /home/$username/.ssh
}

METADATA_ENDPOINT="http://169.254.169.254/latest"
METADATA_TOKEN=$(curl -X PUT "$METADATA_ENDPOINT/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
AWS_REGION=$(curl -s "$METADATA_ENDPOINT/meta-data/placement/region" \
  -H "X-aws-ec2-metadata-token: $METADATA_TOKEN")

ADMIN_USER=admin
ADMIN_SSH_PUBLIC_KEY=$(get_ssh_public_key $ADMIN_USER $AWS_REGION)
assert_public_key_found $ADMIN_SSH_PUBLIC_KEY

TUNNEL_USER=tunnel
TUNNEL_SSH_PUBLIC_KEY=$(get_ssh_public_key $TUNNEL_USER $AWS_REGION)
assert_public_key_found $TUNNEL_SSH_PUBLIC_KEY

add_user_with_authorized_key $ADMIN_USER "$ADMIN_SSH_PUBLIC_KEY"
add_user_with_authorized_key $TUNNEL_USER "$TUNNEL_SSH_PUBLIC_KEY"

# give admin user sudo privileges
echo "$ADMIN_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"$ADMIN_USER"

