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

# slack () { ## message error
#     echo curl -X POST -H 'Content-type: application/json' --data '$1' '$INPUT_SLACK_WEBHOOK_URL'
#     echo ::set-output name=slack_message::$2
#     [[ $2 == "true" ]] && echo "error" || echo "success"
#     echo "exit : $2"
#     [[ $2 == "true" ]] && exit 1 || exit 0
# }

update () { ## deployment container image
    echo "=> Update deployment $1/$2 image: $3 Namespace: $4"
    kubectl set image deployment/$1 $2=$3 --record -n $4 ## && slack $slack_message "false" || slack $slack_message_error "true"
}

update $INPUT_DEPLOYMENT $INPUT_CONTAINER $INPUT_IMAGE:$tag $INPUT_NAMESPACE
echo ::set-output name=slack_message::$slack_message
## TODO rollout version after X seconds
