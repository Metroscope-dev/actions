FROM docker:19.03.2 as runtime
LABEL "maintainer"="Metroscope"

# RUN apk update \
#   && apk upgrade \
#   && apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
