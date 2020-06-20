#!/bin/bash
SECONDS=0

. environment.conf
. ./generate-cloud-init-files.sh
. ./create-servers.sh
$(./set-environment-variables-with-servers-information.sh)
. ./setup-netplan.sh
. ./setup-hosts-file.sh
. ./setup-dns-bind.sh
. ./setup-loadbalancer-haproxy.sh
. ./update-system-config.sh
. ./setup-cri-containerd.sh
. ./setup-masters-tools.sh

printf 'Provision finished in %d hour %d minute %d seconds\n' $((${SECONDS}/3600)) $((${SECONDS}%3600/60)) $((${SECONDS}%60))
