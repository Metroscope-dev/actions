FROM python:3.8-slim-buster as runtime
LABEL "maintainer"="Metroscope"

RUN pip3 install -U pip
RUN pip3 install "setuptools~=53.0.0" "wheel~=0.36.2" "twine~=3.3.0"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
