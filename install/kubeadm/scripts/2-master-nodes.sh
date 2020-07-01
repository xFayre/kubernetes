# Configure Bash Completion
cat <<EOF | tee --append ~/.bashrc

source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

alias cat='bat -p'
EOF
source ~/.bashrc

# WARNING: We should run these commands ONLY on master-1
KUBERNETES_DESIRED_VERSION='1.18' && \
KUBERNETES_VERSION="$(sudo apt-cache madison kubeadm | grep ${KUBERNETES_DESIRED_VERSION} | head -1 | awk '{ print $3 }')" && \
KUBERNETES_BASE_VERSION="${KUBERNETES_VERSION%-*}" && \
LOCAL_IP_ADDRESS=$(grep $(hostname --short) /etc/hosts | awk '{ print $1 }') && \
LOAD_BALANCER_PORT='6443' && \
LOAD_BALANCER_NAME='lb' && \
CONTROL_PLANE_ENDPOINT="${LOAD_BALANCER_NAME}:${LOAD_BALANCER_PORT}" && \
CONTROL_PLANE_ENDPOINT_TEST=$(nc -d ${LOAD_BALANCER_NAME} ${LOAD_BALANCER_PORT} && echo "OK" || echo "FAIL") && \
echo "" && \
echo "LOCAL_IP_ADDRESS...........: ${LOCAL_IP_ADDRESS}" && \
echo "CONTROL_PLANE_ENDPOINT.....: ${CONTROL_PLANE_ENDPOINT} [${CONTROL_PLANE_ENDPOINT_TEST}]" && \
echo "KUBERNETES_BASE_VERSION....: ${KUBERNETES_BASE_VERSION}" && \
echo ""

# Initialize master-1 (=~ 1 minute 30 seconds) - check: http://haproxy.example.com/stats
SECONDS=0 && \
KUBEADM_LOG_FILE="${HOME}/kubeadm-init.log" && \
NODE_NAME=$(hostname --short) && \
sudo kubeadm init \
  --v 9 \
  --node-name "${NODE_NAME}" \
  --apiserver-advertise-address "${LOCAL_IP_ADDRESS}" \
  --kubernetes-version "${KUBERNETES_BASE_VERSION}" \
  --control-plane-endpoint "${CONTROL_PLANE_ENDPOINT}" \
  --upload-certs | tee "${KUBEADM_LOG_FILE}" && \
printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60))

# Config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Watch Nodes and Pods from kube-system namespace
watch -n 3 'kubectl get nodes,pods,services -o wide -n kube-system'

# Install CNI Plugin
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
# https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727
# 
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl apply -f weave-net-cni-plugin.yaml

# Retrieve token information from log file
KUBEADM_LOG_FILE="${HOME}/kubeadm-init.log" && \
grep "\-\-certificate-key" "${KUBEADM_LOG_FILE}" --before 2 | grep \
  --only-matching \
  --extended-regexp "\-\-.*" | sed 's/\-\-control-plane //; s/^/  /'

# Adding a Control Plane Node
NODE_NAME=$(hostname --short) && \
LOCAL_IP_ADDRESS=$(grep ${NODE_NAME} /etc/hosts | head -1 | awk '{ print $1 }') && \
echo "" && \
echo "NODE_NAME..................: ${NODE_NAME}" && \
echo "LOCAL_IP_ADDRESS...........: ${LOCAL_IP_ADDRESS}" && \
sudo kubeadm join lb:6443 \
  --v 5 \
  --control-plane \
  --node-name "${NODE_NAME}" \
  --apiserver-advertise-address "${LOCAL_IP_ADDRESS}" \
  --token 5vzvnv.na18se4q50eax6pw \
  --discovery-token-ca-cert-hash sha256:e7ef59333bd4e63625d144764aacdf870b59fe49533ebff178ab8f36f8330182 \
  --certificate-key 51bc43a4fbf9716b7d70eca5edefe02c16a9485376419a53cb0df38cb0f0b875

# Optional
sudo crictl pull quay.io/jcmoraisjr/haproxy-ingress:latest
