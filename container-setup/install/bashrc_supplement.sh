#!/bin/bash

source /usr/local/kube_ps1/kube-ps1.sh

## Set Defaults
export EDITOR=vim
export PS1='[\W $(ocm_environment) $(kube_ps1)]\$ '
export KUBE_PS1_BINARY=oc
export KUBE_PS1_CLUSTER_FUNCTION=cluster_function
export KUBE_PS1_SYMBOL_ENABLE=false
## Overwrite defaults with user-config
source /root/.config/ocm-container/env.source


complete -C '/usr/local/aws/aws/dist/aws_completer' aws

function cluster_function() {
  oc config view  --minify --output 'jsonpath={..server}' | cut -d. -f2-4
}

function ocm_environment() {
	# based on how ocm-cli works for now, when the default change we will go with it
	export ENV_OCM_URL=${OCM_URL:-production}
	echo "{$(tput setaf 2)${ENV_OCM_URL}$(tput sgr0)}"
}

# note that the PATH will be set only in build time, so changing it after won't work
export PATH=${OCM_PATH_PRE}:${PATH}:${OCM_PATH_POST}
