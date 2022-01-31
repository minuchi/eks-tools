#!/bin/bash
set -euo pipefail
echo "Cluster name?"
read cluster

ekscluster=$(aws eks list-clusters | jq -r ".clusters | index(\"$cluster\")")

if [[ $ekscluster == null ]]; then
    echo "cluster \"$cluster\" does not exist."
    exit;
fi

aws eks update-kubeconfig --name $cluster
