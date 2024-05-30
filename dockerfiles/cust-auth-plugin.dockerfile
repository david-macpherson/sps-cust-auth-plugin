FROM alpine:3.14.1

RUN mkdir logs
RUN mkdir config

WORKDIR /

COPY bin/linux/amd64/cust-auth /cust-auth
COPY ./.thirdparty/bin/grpc_health_probe /bin/grpc_health_probe

ENTRYPOINT ["/cust-auth"]
