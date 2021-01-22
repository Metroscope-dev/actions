FROM python:3.8-slim-buster as runtime
LABEL "maintainer"="Metroscope"

RUN pip3 install setuptools wheel twine

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
