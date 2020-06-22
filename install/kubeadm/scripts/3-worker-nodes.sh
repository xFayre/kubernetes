# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token vcyjar.hm72v66lcnncb8bf \
  --discovery-token-ca-cert-hash sha256:c9e96b9fdcb0c27d480f2364437cb9495d9bec2950d4d9c2d0349cb5913ba039 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
