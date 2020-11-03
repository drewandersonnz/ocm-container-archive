#!/bin/bash

### cd locally
cd $(dirname $0)

### Load config
CONFIG_DIR=${HOME}/.config/ocm-container
export OCM_CONTAINER_CONFIGFILE="$CONFIG_DIR/env.source"

if [ ! -f ${OCM_CONTAINER_CONFIGFILE} ]; then
    echo "Cannot find config file at $OCM_CONTAINER_CONFIGFILE";
    echo "Run the init.sh file to create one."
    echo "exiting"
    exit 1;
fi

source ${OCM_CONTAINER_CONFIGFILE}

operating_system=`uname`

SSH_AGENT_MOUNT="-v ${SSH_AUTH_SOCK}:/tmp/ssh.sock:ro"

if [[ "$operating_system" == "Darwin" ]]
then
  SSH_AGENT_MOUNT="--mount type=bind,src=/run/host-services/ssh-auth.sock,target=/tmp/ssh.sock,readonly"
fi

### start container
${CONTAINER_SUBSYS} run -it --rm --privileged \
-e "OCM_PATH_POST" \
-e "OCM_PATH_PRE" \
-e "OCM_URL=${OCM_URL}" \
-e "SSH_AUTH_SOCK=/tmp/ssh.sock" \
${SSH_AGENT_MOUNT} \
-v ${CONFIG_DIR}:/root/.config/ocm-container:ro \
-v ${HOME}/.aws/config:/root/.aws/config:ro \
-v ${HOME}/.aws/credentials:/root/.aws/credentials:ro \
-v ${HOME}/.ssh:/root/.ssh:ro \
ocm-container ${SSH_AUTH_ENABLE} /bin/bash 
