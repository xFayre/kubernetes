#!/bin/bash
DOMAIN=$1
FORWARD_FILE="forward.${DOMAIN}"
REVERSE_FILE="reverse.${DOMAIN}"

cp /shared/dns/named.conf.options /etc/bind/
cp /shared/dns/named.conf.local /etc/bind/
cp /shared/dns/"${FORWARD_FILE}" /etc/bind/
cp /shared/dns/"${REVERSE_FILE}" /etc/bind/

systemctl restart bind9
systemctl enable bind9

ufw allow 53

named-checkconf /etc/bind/named.conf.local
named-checkzone example.com /etc/bind/"${FORWARD_FILE}"
named-checkzone example.com /etc/bind/"${REVERSE_FILE}"
