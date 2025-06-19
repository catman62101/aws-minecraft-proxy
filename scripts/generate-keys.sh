#!/bin/bash

KEY_TYPE=ed25519
KEY_DIRECTORY=$HOME/.ssh
ADMIN_USER=admin
TUNNEL_USER=tunnel

generate_keys() {
  username=$1
  echo "Generating SSH keypair for user $username."
  ssh-keygen -f $KEY_DIRECTORY/$username -t $KEY_TYPE
  echo "Keys should be found at $KEY_DIRECTORY/$username (private key) and \
$KEY_DIRECTORY/$username.pub (public key)"
}

generate_keys $ADMIN_USER 
generate_keys $TUNNEL_USER 

