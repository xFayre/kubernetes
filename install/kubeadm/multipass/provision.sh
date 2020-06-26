#!/bin/bash
SECONDS=0

if [ ! -e environment.conf ]; then
  echo "You should create a environment.conf file. Try to start cloning templates/environment.conf.sample file."
  echo ""
  echo "  cp templates/environment.conf.sample environment.conf"
  echo ""

  exit 1
fi

provision() {
  . ./00-set-multipass-cidr-in-environment.conf-file.sh
  . ./environment.conf
  . ./01-generate-cloud-init-files.sh
  . ./02-create-servers.sh
  $(./03-set-environment-variables-with-servers-information.sh)
  . ./04-setup-netplan.sh
  . ./05-setup-hosts-file.sh
  # . ./06-setup-dns-bind.sh
  # . ./07-restart-servers.sh
  # . ./08-setup-loadbalancer-haproxy.sh
  # . ./09-update-system-config.sh
  # . ./10-update-local-etc-hosts.sh
  # . ./11-setup-cri-containerd.sh
  # . ./12-setup-masters-tools.sh

  printf 'Provision finished in %d hour %d minute %d seconds\n' $((${SECONDS}/3600)) $((${SECONDS}%3600/60)) $((${SECONDS}%60))
}

provision | tee provision.log
