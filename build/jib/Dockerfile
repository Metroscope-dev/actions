FROM gradle:jdk11 as runtime
LABEL "maintainer"="Metroscope"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
