FROM google/cloud-sdk:288.0.0

COPY entrypoint.sh /entrypoint.sh

RUN apt-get install -qqy jq

ENTRYPOINT ["/entrypoint.sh"]