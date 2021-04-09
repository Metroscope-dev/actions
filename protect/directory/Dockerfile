FROM alpine

LABEL "maintainer"="Metroscope"

RUN apk --update add git less openssh bash && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]