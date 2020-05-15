#!/bin/sh

set -e

if [ ! -d "$HOME/.config/gcloud" ]; then
   if [ -z "${APPLICATION_CREDENTIALS-}" ]; then
      echo "APPLICATION_CREDENTIALS not found. Exiting...."
      exit 1
   fi

   echo "$APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json
   project_id=$(cat gcloud-service-key.json | jq '.project_id')
   gcloud auth activate-service-account --key-file=/tmp/account.json --project "$project_id"
fi

echo ::add-path::/google-cloud-sdk/bin/gcloud
echo ::add-path::/google-cloud-sdk/bin/gsutil

# Update kubeConfig.
gcloud container clusters get-credentials "$CLUSTER_NAME" --project "$project_id" #--zone "$ZONE_NAME"

# verify kube-context
kubectl config current-context

# sh -c "kubectl "
