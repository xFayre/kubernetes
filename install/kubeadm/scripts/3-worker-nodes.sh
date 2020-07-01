# The parameters below are getting from the first Contol Plane Config
SECONDS=0 && \
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token uzw9cx.h6zgn1ymku8fj61l \
  --discovery-token-ca-cert-hash sha256:7995ba9ca8d4bda578f1fba1bfe79408efc9c8640299f5edd74459524f4ea7c1 \
  --v 5 | tee "kubeadm-join.log"

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
