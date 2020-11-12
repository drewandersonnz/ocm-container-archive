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

### SSH Agent Mounting
operating_system=`uname`

SSH_AGENT_MOUNT="-v ${SSH_AUTH_SOCK}:/tmp/ssh.sock:ro"

if [[ "$operating_system" == "Darwin" ]]
then
  SSH_AGENT_MOUNT="--mount type=bind,src=/run/host-services/ssh-auth.sock,target=/tmp/ssh.sock,readonly"
fi

### Kerberos Ticket Mounting
OCM_CONTAINER_KRB5CC_FILE=${KRB5CCNAME:-/tmp/krb5cc_$UID}
if [ -f $OCM_CONTAINER_KRB5CC_FILE ]
then
  KRB5CCFILEMOUNT="-v ${OCM_CONTAINER_KRB5CC_FILE}:/tmp/krb5cc:ro"
fi

### Automatic Login Detection
if [ -n "$1" ]
then
  INITIAL_CLUSTER_LOGIN="-e INITIAL_CLUSTER_LOGIN=$1"
fi

### start container
${CONTAINER_SUBSYS} run -it --rm --privileged \
-e "OCM_URL=${OCM_URL}" \
-e "SSH_AUTH_SOCK=/tmp/ssh.sock" \
-e "KRB5CCNAME=/tmp/krb5cc" \
-e "OFFLINE_ACCESS_TOKEN" \
${INITIAL_CLUSTER_LOGIN} \
-v ${CONFIG_DIR}:/root/.config/ocm-container:ro \
-v ${HOME}/.ssh:/root/.ssh:ro \
-v ${HOME}/.aws/credentials:/root/.aws/credentials:ro \
-v ${HOME}/.aws/config:/root/.aws/config:ro \
${SSH_AGENT_MOUNT} \
${KRB5CCFILEMOUNT} \
${OCM_CONTAINER_LAUNCH_OPTS} \
ocm-container
