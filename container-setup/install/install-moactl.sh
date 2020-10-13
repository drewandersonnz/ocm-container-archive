#!/bin/bash -e

if [ "$I_AM_IN_CONTAINER" != "I-am-in-container" ]; then
  echo "must be run in container";
  exit 1;
fi

source /container-setup/install/helpers.sh
echo "in container";

#export moactlversion=v0.0.5

pushd /usr/local;
# can be changed to git@github.com:openshift/moactl.git when ssh agent is passed to everyone with ease
remove_coloring git clone https://github.com/openshift/moactl.git;
pushd moactl;

# harden the moactl to use the latest tag and not master
# to override remove the following lines
LATEST_TAG=$(git describe --tags);
remove_coloring git checkout ${LATEST_TAG};

remove_coloring make install;
ln -s /root/go/bin/moactl /usr/local/bin/moactl;
moactl completion bash >  /etc/bash_completion.d/moactl
popd;
popd;
