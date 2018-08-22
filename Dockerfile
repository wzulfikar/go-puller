FROM alpine:3.3

# install openssh and ca-cert
RUN apk --no-cache add openssh ca-certificates && update-ca-certificates

# generate ssh keypair without prompt
RUN ssh-keygen -t dsa -N "" -C "" -f /root/.ssh/id_rsa

COPY entrypoint.sh go-puller /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/go-puller"]
