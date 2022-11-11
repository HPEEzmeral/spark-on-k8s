#!/bin/sh

ns="${1:-ranger}"

echo NameSpace: $ns

echo helm uninstall ezsql -n $ns
helm uninstall ranger -n $ns
echo kubectl delete pvc --all -n $ns
kubectl delete pvc --all -n $ns

cdir="/nfs/$ns/mysql-pv"
sudo rm -rf $cdir/*

tree /nfs/$ns

echo kubectl get all -n $ns
kubectl get all -n $ns

