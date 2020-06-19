# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token z542h1.b7khrpvr0vah320o \
  --discovery-token-ca-cert-hash sha256:079edf9fd8338e7dff19644e184b70da7493973653499c1479e37ff44f33add6 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
