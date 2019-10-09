#!/bin/bash

CLUSTERID=$1

if [ "x${OFFLINE_ACCESS_TOKEN}" == "x" ]; then
  echo "FAILURE: must set env variable OFFLINE_ACCESS_TOKEN";
  exit 1;
fi

if [ "$OCM_URL" == "" ];
then
  OCM_URL="https://api.openshift.com"
fi

TOKEN=$(curl \
--silent \
--data-urlencode "grant_type=refresh_token" \
--data-urlencode "client_id=cloud-services" \
--data-urlencode "refresh_token=${OFFLINE_ACCESS_TOKEN}" \
https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token | \
jq -r .access_token)

ocm login --token=$TOKEN --url=$OCM_URL

if [ "$CLUSTERID" != "" ];
then
    ocm cluster login $CLUSTERID --username=$CLUSTER_USERNAME || (echo "FAILURE: unable to login, exiting container." && exit 1)
else
    ocm cluster list --managed --columns id,name,openshift_version | grep -v -e ^$
    exit 1 # exit the container
fi
