#!/bin/bash
set -e

switch_repo () { ## from to
    echo "switch from harbor $1 to $2"
    find . -type f -name '*.gradle' | xargs sed -i "s/harbor.metroscope.tech\/$1/harbor.metroscope.tech\/$2/g"
}

switch_tag () {
    echo "use tag $1 and latest"
    find . -type f -name '*.gradle' | xargs sed -i "/version.=./c\version = \"$1\""
}

tag=${INPUT_TAG##*/}
switch_tag $tag
## Build dev version
./gradlew --no-daemon jib
case "$tag" in
    *"DEV"* | "latest")     exit 0
                            ;;
    *)                      echo "=> create and push prod version : [ $tag, latest ]"
                            switch_repo "dev" "prod"
                            ;;
esac
./gradlew --no-daemon jib

[[ -v "ARTIFACTORYPUBLISH" && $ARTIFACTORYPUBLISH == "true" ]] && ./gradlew --no-daemon artifactoryPublish || exit 0
