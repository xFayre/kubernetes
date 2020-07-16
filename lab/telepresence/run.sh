kubectl config use-context minikube

kubectl create namespace dev

kubectl config set-context minikube --namespace dev

eval $(minikube docker-env)

docker pull datawire/hello-world
docker pull datawire/telepresence-k8s:0.105-30-g8a9aa4e
docker pull yauritux/busybox-curl

cat <<EOF > headless-hello-service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: host-hello
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
---
apiVersion: v1
kind: Endpoints
metadata:
  name: host-hello
subsets:
  - addresses:
      - ip: 172.17.0.1
    ports:
      - port: 8000
EOF

watch -n 2 kubectl get deploy,cm,rs,pods,svc,ep -o wide

