# Container base
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Hugo Extended
ENV HUGO_VERSION=0.152.2
RUN curl -L -o /tmp/hugo.deb \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
    && apt install -y /tmp/hugo.deb \
    && rm /tmp/hugo.deb

# Interactively start
CMD [ "bash" ]
