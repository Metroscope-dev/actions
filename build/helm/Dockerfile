FROM alpine/helm as runtime
LABEL "maintainer"="Metroscope"

ENV HELM_EXPERIMENTAL_OCI 1
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime
