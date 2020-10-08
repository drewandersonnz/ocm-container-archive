#!/bin/bash

CLUSTERID=$1

export CLI="${CLI:-ocm}"
if [[ "${CLI}" == "ocm" ]]; then
  export OCM_LIST_ADDITIONAL_ARG='--managed --columns id,name,api.url,openshift_version,region.id,state,external_id';
  export LOGIN_ENV='--url';
elif [[ "${CLI}" == "moactl" ]]; then
  export LOGIN_ENV='--env';
fi

if [ "x${OFFLINE_ACCESS_TOKEN}" == "x" ]; then
  echo "FAILURE: must set env variable OFFLINE_ACCESS_TOKEN";
  exit 1;
fi

if [ "$OCM_URL" == "" ];
then
  export OCM_URL="https://api.openshift.com"
fi

export TOKEN=$(curl \
--silent \
--data-urlencode "grant_type=refresh_token" \
--data-urlencode "client_id=cloud-services" \
--data-urlencode "refresh_token=${OFFLINE_ACCESS_TOKEN}" \
https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token | \
jq -r .access_token)

"${CLI}" login --token=$TOKEN ${LOGIN_ENV}=$OCM_URL
