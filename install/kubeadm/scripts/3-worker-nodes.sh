# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token i83kzr.t5cm3a6f0g51lkbc \
  --discovery-token-ca-cert-hash sha256:e7644582f143e73f3c60786f779ee82d053ccde99c2b6abfd864ce6c281e70f3 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
