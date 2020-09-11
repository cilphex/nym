FROM rust:1.46-alpine as builder

RUN apk add --no-cache --update \
    alpine-sdk \
    openssl-dev

WORKDIR /src

ARG NYM_REPO=https://github.com/nymtech/nym.git
ARG NYM_VERSION=tags/v0.8.0

# Clone the repo and build the executables
RUN git clone $NYM_REPO . \
    && git checkout $NYM_VERSION \
    && cargo build --release

# Start a new image
FROM alpine as final

# Add bash
RUN apk add --no-cache --update \
    bash

# Copy the compiled binaries from the builder image.
# This reduces the image size from ~1.44gb to ~50mb.
COPY --from=builder /src/target/release/nym-client /bin/
COPY --from=builder /src/target/release/nym-gateway /bin/
COPY --from=builder /src/target/release/nym-mixnode /bin/
COPY --from=builder /src/target/release/nym-socks5-client /bin/
COPY --from=builder /src/target/release/nym-validator /bin/
COPY --from=builder /src/target/release/sphinx-socks /bin/

# Copy start file
COPY "start-nym-client.sh" .

# And make it executable
RUN chmod +x start-nym-client.sh