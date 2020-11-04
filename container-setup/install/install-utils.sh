#!/bin/bash -e

if [ "$I_AM_IN_CONTAINER" != "I-am-in-container" ]; then
  echo "must be run in container";
  exit 1;
fi

echo "in container";

mkdir -p /etc/profile.d;
echo "export PATH=${PATH}:${HOME}/bin" > /etc/profile.d/localbin.sh;
chmod +x /etc/profile.d/localbin.sh;

# Cleanup Home Dir
rm ${HOME}/anaconda*;
rm ${HOME}/original-ks.cfg;
