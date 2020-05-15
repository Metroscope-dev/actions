FROM google/cloud-sdk:290.0.0 as kubernetes
LABEL "maintainer"="Metroscope"

RUN apt-get install -qqy jq
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

FROM kubernetes