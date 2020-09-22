FROM rust:1.46-buster as builder

RUN apt-get update
RUN apt-get install -y \
    pkg-config \
    build-essential \
    libssl-dev

WORKDIR /src

ARG NYM_REPO=https://github.com/nymtech/nym.git
ARG NYM_VERSION=tags/v0.8.0

# Clone the repo and build the executables
RUN git clone $NYM_REPO . \
    && git checkout $NYM_VERSION \
    && cargo build --release

# Start a new image
FROM rust:1.46-buster

RUN apt-get update
RUN apt-get install -y \
    pkg-config \
    build-essential \
    libssl-dev \
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
COPY "start-nym-mixnode.sh" .

# And make it executable
RUN chmod +x start-nym-client.sh
RUN chmod +x start-nym-mixnode.sh
