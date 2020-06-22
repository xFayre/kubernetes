# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 1lo5py.1kc60kvfwxi466bf \
  --discovery-token-ca-cert-hash sha256:6b4bd739e33530ac7996b13a3d0e5eea34aa7271153fd314c34c3080ec8d7d19 \
  --v 3

# Optional
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
