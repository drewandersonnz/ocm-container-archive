#!/bin/bash

### cd locally
cd $(dirname $0)


### Load config
export OCM_CONTAINER_CONFIG="./env.source"

export CONTAINER_SUBSYS="sudo docker"

if [ ! -f ${OCM_CONTAINER_CONFIG} ]; then
    echo "Cannot find config file, exiting";
    exit 1;
fi

source ${OCM_CONTAINER_CONFIG}

# set OCM_URL from commandline if one exists
url=${1:-${OCM_URL}}

### start container
${CONTAINER_SUBSYS} run -it --rm \
-e "OFFLINE_ACCESS_TOKEN=${OFFLINE_ACCESS_TOKEN}" \
-e "OCM_USER=${OCM_USER}" \
-e "OCM_URL=${url}" \
ocm-container /bin/bash ## -c "/container-setup/login.sh $@ && /container-setup/bash-ps1-wrap.sh"
