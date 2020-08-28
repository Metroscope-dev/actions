#!/bin/sh
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

tag=${INPUT_TAG##*/}

update $INPUT_DEPLOYMENT $INPUT_CONTAINER $INPUT_IMAGE:$tag
slack_message="{\"color\":\"#5CE02E\",\"fields\":[{\"title\":\"VERSION\",\"value\":\"${tag}\",\"short\":true},{\"title\":\"Event\",\"value\":\"${GITHUB_EVENT_NAME}\",\"short\":true},{\"title\":\"Actions URL\",\"value\":\"<https://github.com/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}/checks>\",\"short\":false},{\"title\":\"Déployment :rocket:\",\"value\":\"Version $tag has been deployed :100:\",\"short\":false}]}"

echo "$slack_message"
echo ::set-output name=slack_message::$slack_message
## TODO rollout version after X seconds
