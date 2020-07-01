#!/bin/bash
set -e

IPV4_ADDRESS=$1
DOMAIN_NAME=$2

hostnamectl set-hostname "${HOSTNAME}.${DOMAIN_NAME}" &> /dev/null

sed \
  -e "/${HOSTNAME}/d" \
  -e "2i${IPV4_ADDRESS} ${HOSTNAME} ${HOSTNAME}.${DOMAIN_NAME} ${HOSTNAME}.local" \
  -e "/127.0.0.1/d" \
  -e "2i127.0.0.1 localhost" \
  -i /etc/hosts
