# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token e6afxx.a8ok2wf6aou7fmcc \
  --discovery-token-ca-cert-hash sha256:9ff1c1f011cab1dc00d8657c563b53d706e2c700db9a467fb2822cce9659a2af \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
