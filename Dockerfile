FROM alpine:3.11 as alpine
RUN apk add -U --no-cache ca-certificates

FROM golang:1.12.17-alpine3.11 as builder

ADD . .
ENV GOPATH=
RUN apk add git
RUN go build -o /go/bin/drone-registry-plugin
RUN chmod +x /go/bin/drone-registry-plugin

FROM alpine:3.11
EXPOSE 3000

ENV DRONE_DEBUG=false
ENV DRONE_ADDRESS=:3000
ENV GODEBUG netdns=go

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/drone-registry-plugin /bin/drone-registry-plugin

ENTRYPOINT ["/bin/drone-registry-plugin"]