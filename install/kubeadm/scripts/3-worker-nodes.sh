# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 3ml771.c3y98cw12j14040t \
  --discovery-token-ca-cert-hash sha256:48747c98d4763245cbf5da4c1214c4a601194f59f27d80eb4cd64e95df01e828 \
  --v 3

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
