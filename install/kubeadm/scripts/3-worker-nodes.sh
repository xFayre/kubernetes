# The parameters below are getting from the first Contol Plane Config
LOCAL_IP_ADDRESS=$(grep $(hostname --short) /etc/hosts | awk '{ print $1 }') && \
NODE_NAME=$(hostname --short) && \
echo "" && \
echo "NODE_NAME..................: ${NODE_NAME}" && \
echo "LOCAL_IP_ADDRESS...........: ${LOCAL_IP_ADDRESS}" && \
echo ""

SECONDS=0 && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token 5vzvnv.na18se4q50eax6pw \
  --discovery-token-ca-cert-hash sha256:e7ef59333bd4e63625d144764aacdf870b59fe49533ebff178ab8f36f8330182 \
  --v 9 | tee "kubeadm-join.log" && \
printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60))

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl
