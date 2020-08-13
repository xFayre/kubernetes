#!/bin/bash
SECONDS=0

KUBERNETES_BASE_VERSION=$(apt-cache madison kubeadm | head -1 | awk -F '|' '{ print $2 }' | tr -d ' ')
KUBERNETES_VERSION="${KUBERNETES_BASE_VERSION%-*}"

echo "Kubernetes version: ${KUBERNETES_VERSION}"

export MINIKUBE_IN_STYLE=false && \
minikube start \
  --kubernetes-version "v${KUBERNETES_VERSION}" \
  --driver=docker \
  --network-plugin=cni

kubectl config use-context minikube

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

for deploymentName in $(kubectl -n kube-system get deploy -o name); do
   echo "Waiting for: ${deploymentName}"

   kubectl \
     -n kube-system \
     wait --for condition=available \
     --timeout=90s \
     ${deploymentName};
done

elapsed ${SECONDS}
