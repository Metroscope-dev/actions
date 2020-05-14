FROM docker:19.03.2 as runtime
LABEL "repository"="https://github.com/Metroscope-dev/actions"
LABEL "maintainer"="Metroscope"

COPY . .

RUN apk update \
  && apk upgrade \
  && apk add --no-cache git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]