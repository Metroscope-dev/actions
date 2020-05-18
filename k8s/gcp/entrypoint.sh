#!/bin/sh
set -e

function update { ## deployment container image
    echo "=> Update deployment $1/$2 image: $3"
    kubectl set image "deployment/$1 $2=$3" --record
}

function switch_image { ## image tag current_repo wanted_repo
    echo "> switch from repo $3 to $4"
    image=$(echo "$1" | sed "s/harbor.metroscope.tech\/$3/harbor.metroscope.tech\/$4/g"):$2
}

function get_credentials {
    if [ ! -d "$HOME/.config/gcloud" ]; then
        if [ -z "${INPUT_APPLICATION_CREDENTIALS-}" ]; then
            echo "APPLICATION_CREDENTIALS not found. Exiting...."
            exit 1
        fi
        echo "$INPUT_APPLICATION_CREDENTIALS" | base64 -d > /tmp/account.json
        project_id=$(cat /tmp/account.json | jq '.project_id')
        gcloud auth activate-service-account --key-file=/tmp/account.json --project "$project_id"
    fi
    echo ::add-path::/google-cloud-sdk/bin/gcloud
    echo ::add-path::/google-cloud-sdk/bin/gsutil

    # Update kubeConfig.
    gcloud container clusters get-credentials "$INPUT_CLUSTER_NAME" --project "$project_id" --zone "$INPUT_ZONE_NAME"
}

image=$INPUT_IMAGE
registry=$(echo $INPUT_IMAGE | cut -f1 -d"/")


case "$INPUT_TAG" in
    *"DEV"* | "latest")     echo "=> create and push dev version : $VERSION"
                            switch_image "$image" "$tag" "prod" "dev"
                            ;;
    *)                      echo "=> create and push prod version : $VERSION"
                            switch_image "$image" "$tag" "dev" "prod"
                            ;;
esac

echo "> $image"
kubectl get nodes
