FROM alpine:3.3

# install terraform (with only selected components)
RUN apk add --update ca-certificates curl openssl unzip && \
  mkdir -p /opt/terraform && \
  curl -L -o /opt/terraform/terraform.zip \
    https://releases.hashicorp.com/terraform/0.7.2/terraform_0.7.2_linux_amd64.zip && \
  openssl dgst -sha256 /opt/terraform/terraform.zip \
    | grep 'b337c885526a8a653075551ac5363a09925ce9cf141f4e9a0d9f497842c85ad5' \
    || (echo 'shasum mismatch' && false) && \
  unzip /opt/terraform/terraform.zip -d /opt/terraform/ && \
  ln -s /opt/terraform/terraform /usr/local/bin/terraform && \
  rm -rf /opt/terraform/terraform.zip /var/cache/apk/*

CMD ["terraform", "--help"]
