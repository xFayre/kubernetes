SECONDS=0

# The parameters below are getting from the first Contol Plane Config
NODE_NAME=$(hostname --short) && \
sudo kubeadm join lb:6443 \
  --node-name "${NODE_NAME}" \
  --token rpo3vr.16ltvzmwob9uo71z \
  --discovery-token-ca-cert-hash sha256:0d658ff1cb6e94419047ab7c85934b3711b765b501bef3953c2b6b12102fcb88 \
  --v 9 | tee "kubeadm-join.log"

sudo crictl pull nginx:1.18 && \
sudo crictl pull nginx:1.19 && \
sudo crictl pull yauritux/busybox-curl

printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60))
