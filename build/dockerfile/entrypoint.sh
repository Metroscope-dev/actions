#!/bin/sh
set -e

function login { ## regirtry login password
    echo -e "\n=> docker log to $1"
    echo $3 | docker login -u $2 --password-stdin $1
}

function build { ## dockerfile image tag
    echo -e "\n=> docker build $2"
    [[ ! -z "$4" ]] && I=",${4}" && BUILD_ARGS="${I//,/ --build-arg }"
    [[ ! -z "$5" ]] && cd $5
    docker build -f $1 -t $2:$3 -t $2:"latest" $BUILD_ARGS .
}

function push { ## image tag
    echo -e "\n=> docker push $1:[ $2, latest ]"
    docker push $1:$2
    docker push $1:latest
}

function switch_tag { ## input_image tag image
    echo -e "\n=> retag image dev to prod"
    docker tag $1:$2 $3:$2
    docker tag $1:"latest" $3:"latest"
}

function switch_image { ## image current_repo wanted_repo
    echo -e "\n> switch from repo $2 to $3"
    image=$(echo "$1" | sed "s/harbor.metroscope.tech\/$2/harbor.metroscope.tech\/$3/g")
}

registry=$(echo $INPUT_IMAGE | cut -f1 -d"/")
tag=${INPUT_TAG##*/}
## create
login $registry $INPUT_REGISTRY_LOGIN $INPUT_REGISTRY_PASSWORD
build $INPUT_DOCKERFILE $INPUT_IMAGE $tag "$INPUT_BUILD_ARGS" $INPUT_DIRECTORY
push  $INPUT_IMAGE $tag

case "$tag" in
    *"DEV"* | "latest")     exit 0
                            ;;
    *)                      echo "=> create and push prod version : [ $tag, latest ]"
                            switch_image "$INPUT_IMAGE" "dev" "prod"
                            ;;
esac
switch_tag $INPUT_IMAGE $tag $image
push  $image $tag
