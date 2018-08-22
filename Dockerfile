FROM alpine:3.3

# 1. install openssh and ca-cert.
# 2. update ca cert
RUN apk --no-cache add openssh ca-certificates \
	&& update-ca-certificates

COPY entrypoint.sh go-puller /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/go-puller"]
