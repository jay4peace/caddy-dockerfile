ARG CADDY_DOCKER_PROXY_VERSION=master
ARG CADDY_DNS_DUCKDNS_VERSION=master

# 1. BUILDPLATFORM을 명시하여 x86_64(네이티브) 환경에서 빌더를 실행
FROM --platform=$BUILDPLATFORM caddy:builder AS builder
ARG CADDY_DOCKER_PROXY_VERSION
ARG CADDY_DNS_DUCKDNS_VERSION

# 2. Buildx가 자동으로 제공하는 타겟 OS와 아키텍처 변수 사용
ARG TARGETOS
ARG TARGETARCH

# 3. GOOS와 GOARCH 환경변수를 주입하여 "크로스 컴파일"
# QEMU 에뮬레이션 없이 러너의 네이티브 CPU로 빠르게 컴파일
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@${CADDY_DOCKER_PROXY_VERSION} \
    --with github.com/caddy-dns/duckdns@${CADDY_DNS_DUCKDNS_VERSION}

FROM lucaslorentz/caddy-docker-proxy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /usr/bin/caddy /bin/caddy
