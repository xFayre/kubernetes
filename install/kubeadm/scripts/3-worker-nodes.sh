# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token cpnmog.0w1hywtce2j8gkuc \
  --discovery-token-ca-cert-hash sha256:8d5491b8a6f99234e5444cfe04364d3f4f660ae607e0e2c67ba9aa7fe3968ada \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
