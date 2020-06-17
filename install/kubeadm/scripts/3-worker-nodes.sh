# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token jipsfp.1cdec9s7y0tm09ee \
  --discovery-token-ca-cert-hash sha256:206b8bef802ce7f7accb4fd5a8e8e79762360e7cdd47a2b8da7f7045f5ac5c72 \
  --v 10

# Optional
sudo crictl pull nginx:1.19 && \
sudo crictl pull nginx:1.18 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
