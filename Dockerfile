FROM alpine:3.3

COPY files.txt /tmp/

# install terraform (with only selected components)
RUN apk add --update ca-certificates curl openssl unzip && \
  curl -L -o /tmp/terraform.zip \
    https://releases.hashicorp.com/terraform/0.6.14/terraform_0.6.14_linux_amd64.zip && \
  openssl dgst -sha256 /tmp/terraform.zip \
    | grep '6d93290f980df15a453e907ea9a2ca8f8fed41143c220953c911b5174c3e3ab0' \
    || (echo 'shasum mismatch' && false) && \
  unzip /tmp/terraform.zip -d /tmp/terraform && \
  mkdir -p /opt/terraform && \
  xargs -I % cp /tmp/terraform/% /opt/terraform < /tmp/files.txt && \
  ln -s /opt/terraform/terraform /usr/local/bin/terraform && \
  rm -rf /tmp/* /var/cache/apk/*

CMD ["terraform", "--help"]
