# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token lau9ly.7tp7yxf04lfvlwpl \
  --discovery-token-ca-cert-hash sha256:c907c20607a85d90da7172e8c4d97ab1d9d0bd2975dedf7c3d6a610e408a4ee9 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
