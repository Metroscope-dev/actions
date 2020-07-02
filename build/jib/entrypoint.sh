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

github_ref=${GITHUB_REF}
tag=${github_ref/refs\/tags\//}

case "$tag" in
    *"DEV"* )     echo "=> create and push dev version : $VERSION"
                  switch_repo "prod" "dev"
                  switch_tag $tag
                  ;;
    *)            echo "=> create and push prod version : $VERSION"
                  switch_repo "dev" "prod"
                  switch_tag $tag
                  ;;
esac
echo "> $image"
./gradlew --no-daemon artifactoryPublish jib
