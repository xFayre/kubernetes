# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 81sfoe.thnfubzie8qhqkej \
  --discovery-token-ca-cert-hash sha256:e8aa257bea452ba4255788ebfd72a514e2f99aad3f080542054a37697d22f5fb \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
