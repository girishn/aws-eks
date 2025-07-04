aws eks update-kubeconfig --region us-east-1 --name kafka-cluster

kubectl create ns confluent
kubectl config set-context --current --namespace=confluent

helm repo add confluentinc https://packages.confluent.io/helm 
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace=confluent


