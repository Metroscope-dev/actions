#!/bin/sh
set -e


function clone_repository { # github_personal_acces_token repository_link
    repo_access=$(echo "$2" | sed "s/:\/\//:\/\/$1@/g" -)
    echo "=> git clone $repo_access"
    git clone -b $3 --single-branch $repo_access
}

function update_kustomize { # kustomize_path image new_tag old_tag
    cd $1
    kustomize edit set image $2:$4=$2:$3
    git diff kustomization.yaml
    cd -
}

function push_repository { # image new_tag
    git config --global user.email "action@github.com"
    git config --global user.name "GitHub Action"
    git commit -am "[skip ci] Update $1:$2"
    git push
}

clone_repository $INPUT_PAT $INPUT_REPO_LINK $INPUT_BRANCH
cd $(echo ${INPUT_REPO_LINK##*/} | sed 's/.git//g' -)
for p in $(echo $INPUT_PATH | sed "s/,/ /g")
do
    echo "------"
    update_kustomize $p $INPUT_IMAGE $INPUT_NEW_TAG $INPUT_OLD_TAG
done

push_repository $INPUT_IMAGE $INPUT_NEW_TAG
