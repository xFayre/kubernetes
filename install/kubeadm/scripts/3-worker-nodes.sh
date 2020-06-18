# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 76np2a.hpw6m6ea5vx4jn16 \
  --discovery-token-ca-cert-hash sha256:d4de6c3ef2fd363abf95ed09d541d45cc7c2d8b1e0d9227ab3a95333bb3ff422 \
  --v 3

# Optional
sudo crictl pull nginx:1.19 && \
sudo crictl pull nginx:1.18 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
