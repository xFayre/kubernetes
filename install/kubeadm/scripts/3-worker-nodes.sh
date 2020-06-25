# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token m9doz3.3bx1z8pf4hjij4tw \
  --discovery-token-ca-cert-hash sha256:cc1414caf4327df5e1fe8ae5c0447d9f7a3039bef30e4e85958771660852f8bb \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
