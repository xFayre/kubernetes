# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 9ak20k.msflotzrn8zm8lhd \
  --discovery-token-ca-cert-hash sha256:eadbe47063854be4d1499f1de1e3627d97b17c922682f51ff78fa57f8815607a \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
