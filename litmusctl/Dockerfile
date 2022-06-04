FROM jieyu/dind-buster:v0.1.8
# ARG TARGETARCH

ENV KUBECTL_VERSION="v1.19.0"

LABEL maintainer="LitmusChaos"

#Installing minimal packages
# RUN apk update && \
#     apk upgrade --update-cache --available
# RUN apk --no-cache add curl &&\
#     rm -rf /var/cache/apk/*

#Installing kubectl
RUN curl -sLO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && chmod +x kubectl && mv kubectl /usr/bin/kubectl

ADD ./litmusctl .

RUN chmod +x litmusctl && mv litmusctl /usr/bin/litmusctl