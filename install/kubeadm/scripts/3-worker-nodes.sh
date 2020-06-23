# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 5k8d0d.ubi6vbhajnenogm9 \
  --discovery-token-ca-cert-hash sha256:fce6937c52eb6cb90f77e1356b21a023d3a9dbb237b96064675198cb8553bc3c \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
