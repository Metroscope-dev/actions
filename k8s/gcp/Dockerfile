FROM google/cloud-sdk:latest
LABEL "maintainer"="Metroscope"


RUN apt-get install -qqy jq bash

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["version"]