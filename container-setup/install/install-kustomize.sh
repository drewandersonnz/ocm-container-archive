#!/bin/bash -e

if [ "$I_AM_IN_CONTAINER" != "I-am-in-container" ]; then
  echo "must be run in container";
  exit 1;
fi

echo "in container";
source /container-setup/install/helpers.sh


mkdir /usr/local/kustomize;
pushd /usr/local/kustomize;

remove_coloring go mod init tmp
remove_coloring go install sigs.k8s.io/kustomize/kustomize/v3
if [[ ! -f /root/go/bin/kustomize ]]
then 
	echo "the binary was not in the GOBIN, exiting"
	exit 1
fi

ln -s /root/go/bin/kustomize /usr/local/bin/kustomize;

popd
