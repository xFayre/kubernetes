LOCAL_IP_ADDRESS=$(grep $(hostname --short) /etc/hosts | awk '{ print $1 }') && \
NODE_NAME=$(hostname --short) && \
LOAD_BALANCER_PORT='6443' && \
LOAD_BALANCER_NAME='lb' && \
CONTROL_PLANE_ENDPOINT="${LOAD_BALANCER_NAME}:${LOAD_BALANCER_PORT}" && \
CONTROL_PLANE_ENDPOINT_TEST=$(curl -Is ${LOAD_BALANCER_NAME}:${LOAD_BALANCER_PORT} &> /dev/null && echo "OK" || echo "FAIL") && \
echo "" && \
echo "NODE_NAME..................: ${NODE_NAME}" && \
echo "LOCAL_IP_ADDRESS...........: ${LOCAL_IP_ADDRESS}" && \
echo "CONTROL_PLANE_ENDPOINT.....: ${CONTROL_PLANE_ENDPOINT} [${CONTROL_PLANE_ENDPOINT_TEST}]" && \
echo ""

SECONDS=0 && \
sudo kubeadm join "${CONTROL_PLANE_ENDPOINT}" \
  --node-name "${NODE_NAME}" \
  --token t5c613.otln9ayv12d2cmk6 \
  --discovery-token-ca-cert-hash sha256:a3296e44ac9be181bd05406c27007592d6d3298cc5b970cc94cbe6f3e0ea8d1e \
  --v 5 | tee "kubeadm-join.log" && \
printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60)) && \
while true; do
  ip -4 a | sed -e '/valid_lft/d' | awk '{ print $1, $2 }' | sed 'N;s/\n/ /' | tr -d ":" | awk '{ print $2, $4 }' | sort | sed '1iINTERFACE CIDR' | column -t && \
  echo "" && \
  route -n | sed /^Kernel/d | awk '{ print $1, $2, $3, $4, $5, $8 }' | column -t && echo "" && \
  sleep 3 && \
  clear
done

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
