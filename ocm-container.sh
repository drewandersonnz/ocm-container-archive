#!/bin/bash

### Alternate image name, for testing, etc
IMAGE="${1:-ocm-container}"

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

SSH_AGENT_MOUNT="--volume ${SSH_AUTH_SOCK}:/tmp/ssh.sock:ro"

if [[ "$operating_system" == "Darwin" ]]
then
  SSH_AGENT_MOUNT="--mount type=bind,src=/run/host-services/ssh-auth.sock,target=/tmp/ssh.sock,readonly"
fi

### start container
${CONTAINER_SUBSYS} run \
    --interactive \
    --tty \
    --rm \
    --privileged \
    --env "OCM_URL=${OCM_URL}" \
    --env "SSH_AUTH_SOCK=/tmp/ssh.sock" \
    --volume ${CONFIG_DIR}:/root/.config/ocm-container:ro \
    ${SSH_AGENT_MOUNT} \
    --volume ${HOME}/.ssh:/root/.ssh:ro \
    --volume ${HOME}/.aws/credentials:/root/.aws/credentials:ro \
    --volume ${HOME}/.aws/config:/root/.aws/config:ro \
    ${OCM_CONTAINER_LAUNCH_OPTS} \
    ${IMAGE} ${SSH_AUTH_ENABLE} /bin/bash
