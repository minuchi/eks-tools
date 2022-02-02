#!/bin/bash
set -e

cluster=$1
if [[ $cluster == "" ]]; then
    echo "Cluster name?"
    read cluster
fi

ekscluster=$(aws eks list-clusters | jq -r ".clusters | index(\"$cluster\")")

if [[ $ekscluster == null ]]; then
    echo "cluster \"$cluster\" does not exist."
    exit;
fi

aws eks update-kubeconfig --name $cluster
