#!/bin/sh
prefix=$PREFIX
resource_group_name="${prefix}-hcs"
aks_cluster_name="${prefix}-aks"
application_name="${prefix}hcsapp"

az aks get-credentials \
  --name $aks_cluster_name \
  --resource-group $resource_group_name

kubectl config use-context $aks_cluster_name

az extension add -y \
  --source https://releases.hashicorp.com/hcs/0.1.0/hcs-0.1.0-py2.py3-none-any.whl

az hcs create-token \
  --name $application_name \
  --resource-group $resource_group_name \
  --output-kubernetes-secret | kubectl apply -f -

az hcs generate-kubernetes-secret \
  --name $application_name \
  --resource-group $resource_group_name | kubectl apply -f - 
az hcs generate-helm-values \
  --name $application_name \
  --resource-group $resource_group_name \
  --aks-cluster-name $aks_cluster_name > config.yaml

helm repo add hashicorp https://helm.releases.hashicorp.com

helm install hcs -f config.yaml hashicorp/consul
