FROM google/cloud-sdk:alpine
LABEL "maintainer"="Metroscope"

ENV VERSION 3.3.4
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v3.3.4-linux-amd64.tar.gz"

RUN apk add --update --no-cache curl git jq ca-certificates

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.1/bin/linux/amd64/kubectl && chmod u+x kubectl && mv kubectl /bin/kubectl

RUN curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/v3.0.0/kustomize_3.0.0_linux_amd64  -o /bin/kustomize && chmod +x /bin/kustomize

RUN curl -L https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/helm /bin/helm && \
    chmod +x /bin/helm

COPY . .

ENTRYPOINT ["/entrypoint.sh"]
