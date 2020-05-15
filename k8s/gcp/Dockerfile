FROM google/cloud-sdk:latest
LABEL "maintainer"="Metroscope"

RUN apt-get install -qqy jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["version"]