#!/bin/sh
set -e

function login { ## regirtry login password
    echo "=> docker log to $1"
    echo $3 | docker login -u $2 --password-stdin $1
}

function build { ## dockerfile image tag
    echo "=> docker build $2"
    docker build -f $1 -t $2:$3 -t $2:"latest" .
}

function push { ## image tag
    echo "=> docker push $1:[ $2, latest ]"
    docker push $1:$2
    docker push $1:latest
}

function switch_image { ## image current_repo wanted_repo
    echo "> switch from repo $2 to $3"
    image=$(echo "$1" | sed "s/harbor.metroscope.tech\/$2/harbor.metroscope.tech\/$3/g")
}

# password=$INPUT_REGISTRY_PASSWORD
# login=$INPUT_REGISTRY_LOGIN
# image=$INPUT_IMAGE
# github_ref=${GITHUB_REF}
# tag=${github_ref/refs\/tags\//}
# # tag=$INPUT_TAG
# dockerfile=$INPUT_DOCKERFILE
registry=$(echo $INPUT_IMAGE | cut -f1 -d"/")

## TODO delete latest because it's a defautl
case "$tag" in
    *"DEV"* | "latest")     echo "=> create and push dev version : $VERSION"
                            switch_image "$image" "prod" "dev"
                            ;;
    *)                      echo "=> create and push prod version : $VERSION"
                            switch_image "$image" "dev" "prod"
                            ;;
esac
echo "> $image"

login $registry $INPUT_REGISTRY_LOGIN $INPUT_REGISTRY_PASSWORD
build $INPUT_DOCKERFILE $INPUT_IMAGE $INPUT_TAG
push  $INPUT_IMAGE $INPUT_TAG
