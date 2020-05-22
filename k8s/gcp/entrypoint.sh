#!/bin/bash
set -e

########################################
#           Fetch kubeconfig           #
########################################
if [ ! -d "$HOME/.config/gcloud" ]; then
   if [ -z "${APPLICATION_CREDENTIALS-}" ]; then
      echo "APPLICATION_CREDENTIALS not found. Exiting...."
      exit 1
   fi

   if [ -z "${PROJECT_ID-}" ]; then
      echo "PROJECT_ID not found. Exiting...."
      exit 1
   fi

   echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json

   project_id=$(cat /tmp/account.json | jq -r '.project_id')
   gcloud auth activate-service-account --key-file=/tmp/account.json --project $project_id

fi


echo ::add-path::/google-cloud-sdk/bin/gcloud
echo ::add-path::/google-cloud-sdk/bin/gsutil

# Update kubeConfig.
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE_NAME" --project "$PROJECT_ID"

# verify kube-context
kubectl config current-context


########################################
#         rolling update image         #
########################################
update () { ## deployment container image
    echo "=> Update deployment $1/$2 image: $3"
    kubectl set image deployment/$1 $2=$3 --record
}

switch_image () { ## image tag current_repo wanted_repo
    echo "> switch from repo $3 to $4"
    image=$(echo "$1" | sed "s/harbor.metroscope.tech\/$3/harbor.metroscope.tech\/$4/g"):$2
}

github_ref=${GITHUB_REF}
tag=${github_ref/refs\/tags\//}

case "$tag" in
    *"DEV"* | "latest")     echo "=> create and push dev version : $VERSION"
                            switch_image "$INPUT_IMAGE" "$tag" "prod" "dev"
                            ;;
    *)                      echo "=> create and push prod version : $VERSION"
                            switch_image "$INPUT_IMAGE" "$tag" "dev" "prod"
                            ;;
esac

update $INPUT_DEPLOYMENT $INPUT_CONTAINER $image

## TODO rollout version after X seconds
