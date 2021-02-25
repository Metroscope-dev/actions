#!/bin/sh
set -e

PACKAGE_VERSION=${INPUT_PACKAGE_VERSION##*/}
PACKAGE_NAME=$(python3 setup.py --name)

echo "=> Build and push $PACKAGE_NAME==$PACKAGE_VERSION"

echo "=> Check if $PACKAGE_NAME==$PACKAGE_VERSION"
version_already_on_remote_repo=$(pip3 install --index-url https://${INPUT_JFROG_USERNAME}:${INPUT_JFROG_PASSWORD}@metroscope.jfrog.io/metroscope/api/pypi/python-repo/simple ${PACKAGE_NAME}==notexisting 2>&1 | grep "Could not find a version that satisfies the requirement" | grep "[^0-9.]${PACKAGE_VERSION}[^0-9.]" | wc -l)

if [ ${version_already_on_remote_repo} = 1 ]; then
    echo -e "\nERROR: version ${PACKAGE_VERSION} of ${PACKAGE_NAME} is already on JFrog"
    echo -e "distribution not created and not uploaded"
    echo -e "exiting\n"
    exit 1
fi

echo "=> Update pip and install build dependencies"
pip3 install -U pip
pip3 install setuptools>=53.0.0 wheel>=0.36.2

echo "=> Install local package"
pip3 install \
     --index-url https://${INPUT_JFROG_USERNAME}:${INPUT_JFROG_PASSWORD}@metroscope.jfrog.io/metroscope/api/pypi/python-repo/simple \
     --extra-index-url https://pypi.python.org/simple .

echo "=> Create all-requirements.txt"
pip3 freeze --all > all-requirements.txt

echo "=> Build $PACKAGE_NAME==$PACKAGE_VERSION"
python3 setup.py sdist bdist_wheel

echo "=> Build $PACKAGE_NAME==$PACKAGE_VERSION"
twine upload --repository-url https://metroscope.jfrog.io/metroscope/api/pypi/python-repo/ --username ${INPUT_JFROG_USERNAME} --password ${INPUT_JFROG_PASSWORD} dist/*
