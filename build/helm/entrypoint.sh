#!/bin/sh
set -e

function login { ## regirtry login password
    echo -e "\n=> helm login to $1"
    echo $3 | helm registry login $1 \
                   --username $2 \
                   --password-stdin
}

function create { ## path name tag
    echo -e "\n=> helm chart save $2:$3"
    helm chart save $1 $2:$3
    helm chart save $1 $2:latest
}

function push { ## name tag
    echo -e "\n=> helm push $1:[ $2, latest ]"
    helm chart push $1:$2
    helm chart push $1:latest
}

function switch_chart { ## image current_repo wanted_repo
    echo -e "\n> switch from repo $2 to $3"
    chart=$(echo "$1" | sed "s/harbor.metroscope.tech\/$2/harbor.metroscope.tech\/$3/g")
}

registry=$(echo $INPUT_CHART | cut -f1 -d"/")
tag=${INPUT_TAG##*/}
## create
login $registry $INPUT_REGISTRY_LOGIN $INPUT_REGISTRY_PASSWORD
create $INPUT_PATH $INPUT_CHART $tag
push  $INPUT_CHART $tag

case "$tag" in
    *"DEV"* | "latest")     exit 0
                            ;;
    *)                      echo "=> create and push prod version : [ $tag, latest ]"
                            switch_chart "$INPUT_CHART" "dev" "prod"
                            ;;
esac
build $INPUT_PATH $chart $tag
push  $chart $tag
