FROM ubuntu:16.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu55 \
        libunwind8 \
        netcat \
        kubectl

WORKDIR /azp

# Download kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl/
# Download helm https://github.com/helm/helm/blob/master/docs/install.md
ADD ["./kubectl", "./helm", "/usr/local/bin/"]
RUN curl -L https://git.io/get_helm.sh | bash
RUN ls
RUN mv ./helm /usr/local/bin/
RUN chmod +x /usr/local/bin/helm

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]