#!/bin/bash -e

if [ "$I_AM_IN_CONTAINER" != "I-am-in-container" ]; then
  echo "must be run in container";
  exit 1;
fi

echo "in container";
source /container-setup/install/helpers.sh

# export kustomizeversion=v3@v3.5.4

mkdir /usr/local/kustomize;
pushd /usr/local/kustomize;

remove_coloring go mod init tmp;
remove_coloring go get -v -u sigs.k8s.io/kustomize/kustomize/${kustomizeversion};
ln -s /root/go/bin/kustomize /usr/local/bin/kustomize;

popd
