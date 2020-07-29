#!/bin/bash
GIT_BASE_DIR="${HOME}/pessoal/git"
WORK_DIR="${GIT_BASE_DIR}/kubernetes/install/minikube/rbac/dave"

# Create and Access a user empty directory
mkdir -p "${WORK_DIR}" && cd "${WORK_DIR}"

# Create a Minikube Cluster
../../../minikube/run.sh

# Check the Context
kubectl config get-contexts

CURRENT   NAME             CLUSTER          AUTHINFO                                       NAMESPACE
*         minikube         minikube         minikube                                       

# Create a Namespace
kubectl create ns development

# Set the Default Namespace for Minikube context
kubectl config set-context minikube --namespace=development

kubectl apply -f ../rules/

# Create an Multipass Instance that will be used to simulate the user Dave Machine
../../../kubeadm/multipass/examples/instance-launch.sh

# Connect to Instance
multipass shell hal-9000

# Create a dave user
sudo adduser dave

# Configure user to be a sudoer member to facilitate the tests
echo "dave ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/dave

# Change to user dave
sudo su - dave

# Create a hidden directory
mkdir -p "${HOME}/.kube/"

# Create a Private Key
openssl genrsa -out "${USER}.key" 4096

# Certificate Signing Request (CSR) Configuration File
cat <<EOF > csr.cnf
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
CN = ${USER}
O = dev

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
EOF

# Generate CSR File
openssl req \
  -config ./csr.cnf \
  -new -key "${USER}.key" \
  -nodes -out "${USER}.csr"

# On Host
export CSR_FILE="dave.csr"

multipass transfer "hal-9000:/home/dave/${CSR_FILE}" "${PWD}/${CSR_FILE}"

# Encoding the CSR file in base64 and set others variables
export CSR_USER="${CSR_FILE%%.csr}" && \
export CSR_NAME="${CSR_USER}-csr" && \
export CSR_BASE64=$(cat ${CSR_FILE} | base64 | tr -d '\n') && \
echo "CSR_USER............: ${CSR_USER}" && \
echo "CSR_NAME............: ${CSR_NAME}" && \
echo "CSR_BASE64 (length).: ${#CSR_BASE64}"

# Substitution of the CSR_BASE64 env variable and creation of the CertificateSigninRequest resource
cat ../templates/csr.yaml | envsubst | kubectl apply -f -

# Check
kubectl get csr "${CSR_NAME}"

NAME       AGE   REQUESTOR       CONDITION
dave-csr   25s   minikube-user   Pending

# Approve
kubectl certificate approve "${CSR_NAME}"

# Check
kubectl get csr "${CSR_NAME}"

NAME       AGE   REQUESTOR       CONDITION
dave-csr   53s   minikube-user   Approved,Issued

# Extract Certificate
kubectl get csr "${CSR_NAME}" \
  -o jsonpath='{.status.certificate}' \
  | base64 --decode > "${CSR_USER}.crt"

# Show Certificate Information
openssl x509 -in "./${CSR_USER}.crt" -noout -text | grep "Subject:.*"
openssl x509 -in "./${CSR_USER}.crt" -noout -text | less

# Generate User Kube Config File
cat ../templates/kubeconfig.yaml

# User identifier
export CURRENT_CONTEXT=$(kubectl config current-context)
export CLUSTER_NAME="${CURRENT_CONTEXT}"
export CLIENT_CERTIFICATE_DATA=$(kubectl get csr ${CSR_NAME} -o jsonpath='{.status.certificate}')

# Base Command to Extract "server" and "cluster.certificate-authority-data"
BASE_COMMAND="kubectl config view -o jsonpath='{.clusters[?(@.name==\"%s\")].cluster.%s}' --raw"

# Cluster Certificate Authority and API Server endpoint
COMMAND=$(printf "${BASE_COMMAND}" "${CLUSTER_NAME}" "certificate-authority-data") && export CERTIFICATE_AUTHORITY_DATA=$(${COMMAND} | tr -d "'")
COMMAND=$(printf "${BASE_COMMAND}" "${CLUSTER_NAME}" "server")                     && export CLUSTER_ENDPOINT=$(${COMMAND} | tr -d "'")

export CERTIFICATE_AUTHORITY_DATA=$(cat ${HOME}/.minikube/ca.crt | sed '1d;$d' | tr -d "\n")

echo "USER........................: ${CSR_USER}" && \
echo "CLUSTER_NAME................: ${CLUSTER_NAME}" && \
echo "CLIENT_CERTIFICATE_DATA.....: ${#CLIENT_CERTIFICATE_DATA} (length)" && \
echo "CERTIFICATE_AUTHORITY_DATA..: ${#CERTIFICATE_AUTHORITY_DATA} (length)" && \
echo "CLUSTER_ENDPOINT............: ${CLUSTER_ENDPOINT}"

# Only show a template with values
cat ../templates/kubeconfig.yaml | envsubst | yq r -

# Save it to a file
cat ../templates/kubeconfig.yaml | envsubst > "config.yaml"

multipass transfer "${PWD}/config.yaml" "hal-9000:/home/ubuntu/config"

cp ${HOME}/.minikube/ca.crt .

multipass transfer "${PWD}/ca.crt" "hal-9000:/home/ubuntu/ca.crt"

# Back to User Machine
sudo mv /home/ubuntu/config ${HOME}/.kube/config
sudo mv /home/ubuntu/ca.crt ${HOME}/.kube/minikube-ca.crt
sudo chown -R ${USER}:${USER} /home/dave/.kube/

sudo apt-get update -q && \
sudo curl --silent "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | sudo apt-key add -

# Add Kubernetes Repository
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Update package list
sudo apt-get update -q

# Set Kubernetes Version
KUBERNETES_DESIRED_VERSION='1.17.7' && \
KUBERNETES_VERSION="$(apt-cache madison kubeadm | grep ${KUBERNETES_DESIRED_VERSION} | head -1 | awk '{ print $3 }')" && \
KUBERNETES_IMAGE_VERSION="${KUBERNETES_VERSION%-*}" && \
clear && \
echo "" && \
echo "KUBERNETES_DESIRED_VERSION.: ${KUBERNETES_DESIRED_VERSION}" && \
echo "KUBERNETES_VERSION.........: ${KUBERNETES_VERSION}" && \
echo ""

# Install Kubelet, Kubeadm and Kubectl
#   all =~ 1 minute 30 seconds
SECONDS=0 && \
sudo apt-get install --yes -q \
  kubectl="${KUBERNETES_VERSION}" | grep --invert-match --extended-regexp "^Hit|^Get|^Selecting|^Preparing|^Unpacking" && \
sudo apt-mark hold \
  kubectl
printf 'Elapsed time: %02d:%02d\n' $((${SECONDS} % 3600 / 60)) $((${SECONDS} % 60))

# Add the User Private Key to kube config file
kubectl config set-credentials ${USER} \
  --client-key=${USER}.key \
  --embed-certs=true

# Try to get Pods
kubectl get pods -n development
kubectl get pods -n default

mkdir nginx && cd nginx

cat <<EOF > nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: development
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.18
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: development
spec:
  selector:
    app: nginx
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f .

watch kubectl -n development get deploy,pods,services -o wide
