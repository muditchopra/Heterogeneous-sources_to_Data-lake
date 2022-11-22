FROM alpine:latest as builder

ENV TERRAFORM_VERSION=1.2.9


RUN apk add --update git curl openssh && \
    curl -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    curl -o terraform_${TERRAFORM_VERSION}_SHA256SUMS https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sed -i '/.*linux_amd64.zip/!d' terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -c terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin

FROM alpine:3.13.5

RUN apk add --update --no-cache ca-certificates jq python3-dev python3 make git openssl gettext bash curl openjdk8-jre graphviz ttf-freefont \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && pip install 'awscli==1.19.72' \
    && pip install 'pydot' \
    && pip install 'git-remote-codecommit'

COPY --from=builder /bin/terraform /bin/terraform
RUN addgroup -g 500 core && \
    adduser  -u 500 -G core -h /opt -D core && \
    chown -R core:core /opt

RUN pip install pip -U && apk --no-cache add jq zip git bash build-base libffi-dev openssl-dev curl unixodbc unixodbc-dev coreutils docker-cli
COPY requirements.txt /opt/requirements.txt
RUN pip install -r /opt/requirements.txt && rm -rf /root/.cache

COPY test.sh /opt/test.sh
RUN chmod u+x,g+x,o+x /opt/test.sh