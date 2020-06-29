#!/bin/bash
export IP_SERVER="$1"
export DOMAIN_NAME="$2"
export IP_DNS="$3"

echo "IP_SERVER...............: ${IP_SERVER}"
echo "IP_DNS..................: ${IP_DNS}"
echo "DOMAIN_NAME.............: ${DOMAIN_NAME}"

# Add a Static Route for Kubernetes Service Communication
envsubst < /home/vagrant/.netplan-vagrant-template.yaml | tee /etc/netplan/60-vagrant.yaml

# Apply Changes
netplan apply
