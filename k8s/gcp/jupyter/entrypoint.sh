#!/bin/sh
set -e

########################################
#      init slack error message        #
########################################
tag=${INPUT_TAG##*/}
project=$(echo $INPUT_IMAGE | cut -d"/" -f3):$tag
slack_message_error="{\"color\":\"#D63512\",\"fields\":[{\"title\":\"Cluster\",\"value\":\"${CLUSTER_NAME}\",\"short\":true},{\"title\":\"Event\",\"value\":\"${GITHUB_EVENT_NAME}\",\"short\":true},{\"title\":\"Actions URL\",\"value\":\"<https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks>\",\"short\":false},{\"title\":\"Déployment :smiling_imp:\",\"value\":\"Error: Project \`$project\` hasn't been deployed :sob:\",\"short\":false}]}"
slack_message="{\"color\":\"#5CE02E\",\"fields\":[{\"title\":\"Cluster\",\"value\":\"${CLUSTER_NAME}\",\"short\":true},{\"title\":\"Event\",\"value\":\"${GITHUB_EVENT_NAME}\",\"short\":true},{\"title\":\"Actions URL\",\"value\":\"<https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks>\",\"short\":false},{\"title\":\"Déployment :rocket:\",\"value\":\"Project \`$project\` has been deployed :100:\",\"short\":false}]}"

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

singleuser.image.name
singleuser.image.tag

yq ".singleuser.image.name = \"$INPUT_IMAGE\"" config.yaml | yq ".singleuser.image.tag = \"$INPUT_TAG\"" -y > values.yaml

echo "=> Update jupyterhub  $INPUT_NAMESPACE:$INPUT_RELEASE"
helm upgrade --install $INPUT_RELEASE jupyterhub/jupyterhub    --namespace $INPUT_NAMESPACE    --version=0.9.0    --values values.yaml    --post-renderer=./hook.sh
echo ::set-output name=slack_message::$slack_message
