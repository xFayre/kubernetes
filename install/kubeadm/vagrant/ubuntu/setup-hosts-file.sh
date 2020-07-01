#!/bin/bash
set -e

IPV4_ADDRESS=$1
DOMAIN_NAME=$2

sed -e "s/^.*${HOSTNAME}.*/${IPV4_ADDRESS} ${HOSTNAME} ${HOSTNAME}.${DOMAIN_NAME} ${HOSTNAME}.local/" -i /etc/hosts

hostnamectl set-hostname "${HOSTNAME}.${DOMAIN_NAME}" &> /dev/null
