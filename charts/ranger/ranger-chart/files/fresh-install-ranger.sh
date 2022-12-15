#!/bin/sh

ns="${1:-ranger}"

echo NameSpace: $ns

echo helm install ranger ./ranger --namespace $ns --create-namespace --wait
helm install ranger ./ranger-chart --namespace $ns --create-namespace --wait
echo kubectl get all -n $ns
kubectl get all -n $ns
