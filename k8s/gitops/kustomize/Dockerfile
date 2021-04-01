FROM alpine:3.13
LABEL "maintainer"="Metroscope"

ENV KUSTOMIZE_VERSION=4.0.1

WORKDIR /app

RUN apk add --no-cache \
      curl \
      git

RUN curl -sLf https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz -o kustomize.tar.gz \
    && tar xf kustomize.tar.gz \
    && mv kustomize /usr/local/bin \
    && chmod +x /usr/local/bin/kustomize \
    && rm -rf ./*

ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]