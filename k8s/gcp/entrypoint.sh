#!/bin/bash

echo "=> summary:"
echo "  json_key: $INPUT_JSON_KEY"
echo "  cluster: $INPUT_CLUSTER"
echo "  image: $INPUT_IMAGE"
echo "  deployment: $INPUT_DEPLOYMENT"
echo "  container: $INPUT_CONTAINER"


base64 --decode <<< $INPUT_JSON_KEY > gcloud-service-key.json
project=$(cat gcloud-service-key.json | jq '.project_id')
account=$(cat gcloud-service-key.json | jq '.client_email')
echo -e "=> project: $project"
echo -e "=> account: $account"
gcloud auth activate-service-account $account --key-file=./gcloud-service-key.json --project=$project
gcloud config set project $project
gcloud container clusters get-credentials $INPUT_CLUSTER --project $project
# kubectl get nodes
# echo "::set-output name=current::{$cluster##*:}"
