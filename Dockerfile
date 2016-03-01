FROM alpine:3.3

COPY files.txt /tmp/

# install terraform (with only selected components)
RUN apk add --update ca-certificates curl openssl unzip && \
  curl -L -o /tmp/terraform.zip \
    https://releases.hashicorp.com/terraform/0.6.12/terraform_0.6.12_linux_amd64.zip && \
  openssl dgst -sha256 /tmp/terraform.zip \
    | grep '28c258e60157f78ce957c69f32eb78924d1aaf9f0c07cf53c90bf5c7ee4090e7' \
    || (echo 'shasum mismatch' && false) && \
  unzip /tmp/terraform.zip -d /tmp/terraform && \
  mkdir -p /opt/terraform && \
  xargs -I % cp /tmp/terraform/% /opt/terraform < /tmp/files.txt && \
  ln -s /opt/terraform/terraform /usr/local/bin/terraform && \
  rm -rf /tmp/* /var/cache/apk/*

CMD ["terraform", "--help"]
