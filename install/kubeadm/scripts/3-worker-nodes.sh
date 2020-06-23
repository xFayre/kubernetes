# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --v 3 && \
  --node-name "${NODE_NAME}" \
  --token mi16ou.w5u92i0126nqy5ir \
  --discovery-token-ca-cert-hash sha256:1ec246fbab43563c044849ddab2a9d3ec1d824f8b5375b0b89fe6e7cc729d14f \
sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl && \
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
