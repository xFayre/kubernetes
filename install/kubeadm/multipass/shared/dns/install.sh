#!/bin/bash
FORWARD_FILE="forward.example.com"
REVERSE_FILE="reverse.example.com"

cp /shared/dns/named.conf.options /etc/bind/
cp /shared/dns/named.conf.local /etc/bind/
cp /shared/dns/"forward.example.com" /etc/bind/
cp /shared/dns/"reverse.example.com" /etc/bind/

systemctl restart bind9
systemctl enable bind9

ufw allow 53

named-checkconf /etc/bind/named.conf.local
named-checkzone example.com /etc/bind/"forward.example.com"
named-checkzone example.com /etc/bind/"reverse.example.com"
