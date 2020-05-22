#!/bin/sh
set -o errexit

latestTag=''
latestIncrement=0

targetTag=''
targetIncrement=latestIncrement

setTargetTag() {
    # Find current year and month
    currentYear=$(date +'%y')
    currentMonth=$(date +'%m')

    # Find latest tag corresponding to current year and month
    latestTag=$(git tag | grep "${currentYear}\.${currentMonth}\-DEV.*" | sort | tail -n 1)
    latestIncrement=$(echo "${latestTag}" | sed "s/${currentYear}\.${currentMonth}\-DEV//" | sed 's/^0*//')
    echo "Latest tag for this month: '${latestTag}'"

    # If latestTag is not null, increment targetIncrement by 1 and format using 3 digits
    if [ -z "${latestIncrement}" ]; then
      targetIncrement=$(printf "%03d" 1)
    else
      targetIncrement=$((latestIncrement + 1))
      targetIncrement=$(printf "%03d" ${targetIncrement})
    fi

    # Define target tag
    targetTag="${currentYear}.${currentMonth}-DEV${targetIncrement}"
    echo "Target tag: '${targetTag}'"
}

performTagging() {
    # echo "Creating and pushing tag: '${targetTag}'"
    echo ::set-output name=tag::$targetTag
}


git fetch --all --tags
github_ref=${GITHUB_REF}
grep -q "tags" | $github_ref && git_tag=${github_ref/refs\/tags\//} || git_tag=""
if [ ! -z $git_tag ];
then
    targetTag=$git_tag
else
    setTargetTag
fi
performTagging
