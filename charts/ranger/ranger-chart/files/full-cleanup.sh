#!/bin/sh

ns="${1:-ranger}"

echo NameSpace: $ns

echo helm uninstall ranger -n $ns
helm uninstall ranger -n $ns
echo kubectl delete pvc --all -n $ns
kubectl delete pvc --all -n $ns

echo kubectl get all -n $ns
kubectl get all -n $ns

