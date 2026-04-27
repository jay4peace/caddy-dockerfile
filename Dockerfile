ARG CADDY_DOCKER_PROXY_VERSION=master
ARG CADDY_DNS_DUCKDNS_VERSION=master

FROM caddy:builder AS builder
ARG CADDY_DOCKER_PROXY_VERSION
ARG CADDY_DNS_DUCKDNS_VERSION
RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@${CADDY_DOCKER_PROXY_VERSION} \
    --with github.com/caddy-dns/duckdns@${CADDY_DNS_DUCKDNS_VERSION}

FROM lucaslorentz/caddy-docker-proxy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /usr/bin/caddy /bin/caddy
