#!/bin/bash
set -e

message=''
ex=0

for branch in $(echo $INPUT_WHITELIST_BRANCH | sed "s/,/ /g")
do
    if [[ "$branch" == "$GITHUB_HEAD_REF" ]]
    then
        exit 0
    fi
done

diff=$(git diff --name-only origin/$GITHUB_BASE_REF)
for d in $diff
do
    echo "$d"
    if [[ "$d" == *"$INPUT_PROTECT"* ]]; then
        if [ -z "$message" ]; then
            message=$d
        else
            message=$message'%0A'$d
        fi
        ex="1"
    fi
done
if [[ $ex == "1" ]]
then
    echo "::set-output name=message::$message"
    exit 1
fi
