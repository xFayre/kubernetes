# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 9wx878.w93usp7t5r0svr80 \
  --discovery-token-ca-cert-hash sha256:ea43cc95279959155212c9eb5820f2ca9ce60f9e902075563abc3aea0e0b36a1 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
