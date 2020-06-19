# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 1an7eo.rthtny3q7f0rix22 \
  --discovery-token-ca-cert-hash sha256:091bce65bda860b496559974194d59fda055c1f4c64c27aab05d92bcf13211a1 \
  --v 3

# Optional
sudo crictl pull nginx:1.19 && \
sudo crictl pull nginx:1.18 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
