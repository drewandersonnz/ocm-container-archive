#!/bin/bash

OCM_ENV=$1
OCM_CLUSTER=$2

if [ "$OCM_ENV" == "" ];
then
    echo ""
    echo "usage: $0 {int,stage,prod} [clusterid]"
    echo "   If clusterid is omitted all managed clusters is listed."
    exit 1
fi

source "ocm-$OCM_ENV.source"

podman run -it --rm \
    -e "OFFLINE_ACCESS_TOKEN=${OFFLINE_ACCESS_TOKEN}" \
    -e "OCM_URL=${OCM_URL}" \
    -e "CLUSTER_USERNAME=${CLUSTER_USERNAME}" \
    ocm-container /bin/bash -c "/container-setup/login.sh ${@:2} && PS1='$CONTAINER_PS1' /bin/bash"
