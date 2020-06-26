#!/bin/bash
SECONDS=0

if [ ! -e environment.conf ]; then
  echo "You should create a environment.conf file. Try to start cloning templates/environment.conf.sample file."
  echo ""
  echo "  cp templates/environment.conf.sample environment.conf"
  echo ""

  exit 1
fi

log_time() {
  MESSAGE=$1
  
  printf '%d hours %d minutes %d seconds - %s.\n' $((${SECONDS}/3600)) $((${SECONDS}%3600/60)) $((${SECONDS}%60)) "${MESSAGE}"

  echo ""
}

provision() {
  . ./00-set-multipass-cidr-in-environment.conf-file.sh
  . ./environment.conf
  . ./01-generate-cloud-init-files.sh
  . ./02-create-servers.sh;                                       log_time "servers created"
  $(./03-set-environment-variables-with-servers-information.sh)
  . ./04-setup-netplan.sh
  . ./05-setup-hosts-file.sh
  . ./update-servers.sh;                                          log_time "servers updated"
  . ./06-setup-dns-bind.sh;                                       log_time "bind 9 configured"
  . ./07-restart-servers.sh;                                      log_time "servers restarted"
  . ./08-setup-loadbalancer-haproxy.sh;                           log_time "haproxy configured"
  . ./09-update-system-config.sh
  . ./10-update-local-etc-hosts.sh
  # . ./11-setup-cri-containerd.sh
  # . ./12-setup-masters-tools.sh

  log_time "servers provisioned"
}

provision | tee provision.log
