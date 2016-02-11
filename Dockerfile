FROM alpine:3.3

COPY files.txt /tmp/

# install terraform (with only selected components)
RUN apk add --update ca-certificates curl openssl unzip && \
  curl -L -o /tmp/terraform.zip \
    https://releases.hashicorp.com/terraform/0.6.11/terraform_0.6.11_linux_amd64.zip && \
  openssl dgst -sha256 /tmp/terraform.zip \
    | grep 'f451411db521fc4d22c9fe0c80105cf028eb8df0639bac7c1e781880353d9a5f' \
    || (echo 'shasum mismatch' && false) && \
  unzip /tmp/terraform.zip -d /tmp/terraform && \
  mkdir -p /opt/terraform && \
  xargs -I % cp /tmp/terraform/% /opt/terraform < /tmp/files.txt && \
  ln -s /opt/terraform/terraform /usr/local/bin/terraform && \
  rm -rf /tmp/* /var/cache/apk/*

CMD ["terraform", "--help"]
