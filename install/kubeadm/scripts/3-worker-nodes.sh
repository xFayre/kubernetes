# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb.example.com:6443 \
  --node-name "${NODE_NAME}" \
  --token 7z397n.ib2u6h3z6amo5hea \
  --discovery-token-ca-cert-hash sha256:faa0db004bc44bf81b956f1d304bb0beb640616aa1d8417d05d5ab456c1769ed \
  --v 1

# Optional
sudo crictl pull nginx:1.19 && \
sudo crictl pull nginx:1.18 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
