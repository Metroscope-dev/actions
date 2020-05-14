#!/bin/sh
set -e

function login { ## regirtry login password
    echo "=> docker log to $1"
    echo $3 | docker login -u $2 --password-stdin $1
}

function build { ## dockerfile image
    echo "=> docker build $1"
    docker build -f $1--rm -t $2 .
}

function push { ## image
    echo "=> docker push $1"
    docker push $1
}

function switch_image { ## image tag current_repo tag wanted_repo image
    echo "> switch from repo $3 to $4"
    image=$(echo "$1" | sed "s/harbor.metroscope.tech\/$3/harbor.metroscope.tech\/$4/g"):$2
}

password="$1"
login="$2"
image="$3"
tag="$4"
dockerfile="$5"
registry=$(echo $image | cut -f1 -d"/")

case "$tag" in
    *"DEV"* | "latest")     echo "=> create and push dev version : $VERSION"
                            switch_image "$image" "$tag" "prod" "dev"
                            ;;
    *)                      echo "=> create and push prod version : $VERSION"
                            switch_image "$image" "$tag" "dev" "prod"
                            ;;
esac
echo "> $image"

login $registry $login $password
build $dockerfile $image
push  $image
