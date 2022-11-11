#!/bin/sh

ns="${1:-ranger}"

echo NameSpace: $ns

echo Making sub-directories for MYSQL /nfs/$ns/mysql-pv
mkdir -p /nfs/$ns/mysql-pv >/dev/null 2>&1
chmod 777 /nfs/$ns/mysql-pv

echo chmod -R 777 /nfs/$ns
chmod -R 777 /nfs/$ns

echo tree /nfs/$ns
tree /nfs/$ns

echo helm install ranger ./ranger --namespace $ns --create-namespace --wait
helm install ranger ./ranger --namespace $ns --create-namespace --wait
echo kubectl get all -n $ns
kubectl get all -n $ns