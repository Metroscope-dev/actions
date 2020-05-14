#!/bin/bash

# echo "json_key :"
# echo "---------------------------------------------"
# echo "$1"
# echo "---------------------------------------------"
# echo "cluster :"
# echo "---------------------------------------------"
# echo "$2"
# echo "---------------------------------------------"
# echo "image :"
# echo "---------------------------------------------"
# echo "$3"
# echo "---------------------------------------------"
# echo "deployment :"
# echo "---------------------------------------------"
# echo "$4"
# echo "---------------------------------------------"
# echo "container :"
# echo "---------------------------------------------"
# echo "$5"
# echo "---------------------------------------------"

# key= key in base64
cluster=helium-alpha

# gcloud config configurations create MY_CONFIG
# gcloud config configurations activate MY_CONFIG

base64 --decode <<< $key > gcloud-service-key.json
project=$(cat gcloud-service-key.json | jq '.project_id')
account=$(cat gcloud-service-key.json | jq '.client_email')
echo -e "=> project: $project"
echo -e "=> account: $account"
gcloud auth activate-service-account $account --key-file=./gcloud-service-key.json --project=$project
# gcloud config set project $project
# gcloud container clusters get-credentials $cluster --project $project
# kubectl get nodes
# echo "::set-output name=current::{$cluster##*:}"
