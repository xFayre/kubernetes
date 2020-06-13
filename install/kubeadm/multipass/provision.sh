#!/bin/bash
SECONDS=0

source environment.conf

for SERVER in dns loadbalancer master-{1..3} worker-{1..3}; do
  CLOUD_INIT_TEMPLATE_NAME=$(awk -F '-' '{ print $1 }' <<< "${SERVER}")
  CLOUD_INIT_FILE="cloud-init/${SERVER}.yaml"

  export SERVER_HOST_NAME="${SERVER}"
  
  cat "cloud-init/${CLOUD_INIT_TEMPLATE_NAME}.yaml" | envsubst > "${CLOUD_INIT_FILE}"

  SERVER_MEMORY_KEY="${CLOUD_INIT_TEMPLATE_NAME^^}_MEMORY"
  SERVER_CPU_COUNT_KEY="${CLOUD_INIT_TEMPLATE_NAME^^}_CPU_COUNT"
  SERVER_DISK_SIZE_KEY="${CLOUD_INIT_TEMPLATE_NAME^^}_DISK_SIZE"

  echo ""
  echo "SERVER...............................: ${SERVER}.${DOMAIN_NAME}"
  echo "CLOUD_INIT_FILE......................: ${CLOUD_INIT_FILE}"
  echo "SERVER_MEMORY_KEY....................: ${!SERVER_MEMORY_KEY}"
  echo "SERVER_CPU_COUNT.....................: ${!SERVER_CPU_COUNT_KEY}"
  echo "SERVER_DISK_SIZE.....................: ${!SERVER_DISK_SIZE_KEY}"

  multipass launch \
    --cpus "${!SERVER_CPU_COUNT_KEY}" \
    --disk "${!SERVER_DISK_SIZE_KEY}" \
    --mem "${!SERVER_MEMORY_KEY}" \
    --name "${SERVER}" \
    --cloud-init "${CLOUD_INIT_FILE}"

  multipass mount ../vagrant/ubuntu "${SERVER}":/home/ubuntu/scripts

  echo ""
done

IP_DNS=$(multipass list | grep -E "^dns.*" | awk '{ print $3 }')
IP_LOAD_BALANCER=$(multipass list | grep -E "^lb.*" | awk '{ print $3 }')

echo "DOMAIN_NAME..........................: ${DOMAIN_NAME}"
echo "IP_DNS...............................: ${IP_DNS}"
echo "IP_LOAD_BALANCER.....................: ${IP_LOAD_BALANCER}"

printf 'Server were created in %d hour %d minute %d seconds\n' $((${SECONDS}/3600)) $((${SECONDS}%3600/60)) $((${SECONDS}%60))
