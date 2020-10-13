#!/bin/bash -e

if [ "$I_AM_IN_CONTAINER" != "I-am-in-container" ]; then
  echo "must be run in container";
  exit 1;
fi

echo "in container";
source /container-setup/install/helpers.sh

# export controllergenversion=v0.3.0

mkdir /usr/local/controller-gen;
pushd /usr/local/controller-gen;

remove_coloring go mod init tmp;
remove_coloring go get -v -u sigs.k8s.io/controller-tools/cmd/controller-gen@${controllergenversion};
ln -s /root/go/bin/controller-gen /usr/local/bin/controller-gen;

popd
