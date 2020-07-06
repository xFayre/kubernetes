LOCAL_IP_ADDRESS=$(grep $(hostname --short) /etc/hosts | awk '{ print $1 }') && \
NODE_NAME=$(hostname --short) && \
LOAD_BALANCER_PORT='6443' && \
LOAD_BALANCER_NAME='lb' && \
CONTROL_PLANE_ENDPOINT="${LOAD_BALANCER_NAME}:${LOAD_BALANCER_PORT}" && \
CONTROL_PLANE_ENDPOINT_TEST=$(curl -Is ${LOAD_BALANCER_NAME}:${LOAD_BALANCER_PORT} &> /dev/null && echo "OK" || echo "FAIL") && \
clear && \
echo "" && \
echo "NODE_NAME..................: ${NODE_NAME}" && \
echo "LOCAL_IP_ADDRESS...........: ${LOCAL_IP_ADDRESS}" && \
echo "CONTROL_PLANE_ENDPOINT.....: ${CONTROL_PLANE_ENDPOINT} [${CONTROL_PLANE_ENDPOINT_TEST}]" && \
echo ""

SECONDS=0 && \
sudo kubeadm join "${CONTROL_PLANE_ENDPOINT}" \
  --node-name "${NODE_NAME}" \
  --token vqrpv5.m8n442w7k42zoxdi \
  --discovery-token-ca-cert-hash sha256:ca1979ab834f248f87ced5b312a7018a6a293b422a281cb89ac9ffcfa59145e9 \
  --v 5 | tee "kubeadm-join.log" && \
printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60)) && \
./monitor-network-changes.sh

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
