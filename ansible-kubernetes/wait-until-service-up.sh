#!/bin/sh -xe

# Wait until hostname is available
until kubectl get service animals -o json | jq -re .status.loadBalancer.ingress[0].hostname; do
    sleep 15;
done;

# Wait until animals application is up
hostname=$(kubectl get service animals -o json | jq -re .status.loadBalancer.ingress[0].hostname)
until curl -sSf $hostname; do
    sleep 15;
done;

echo "Load-balancer URL: $hostname"
