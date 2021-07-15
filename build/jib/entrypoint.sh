#!/bin/bash
set -e

switch_repo () { ## from to
    echo "switch from harbor $1 to $2"
    sed -i "s/harbor.metroscope.tech\/$1/harbor.metroscope.tech\/$2/g" gradle.properties
}

switch_tag () {
    echo "use tag $1 and latest"
    sed -i "/^version=./c\version=$1" gradle.properties
}

tag=${INPUT_TAG##*/}
switch_tag $tag
## Build dev version + publish on artifactory
./gradlew --no-daemon jib artifactoryPublish --stacktrace

case "$tag" in
    *"DEV"* | "latest")     exit 0
                            ;;
    *)                      echo "=> create and push prod version : [ $tag, latest ]"
                            switch_repo "dev" "prod"
                            ./gradlew --no-daemon jib
                            ;;
esac
