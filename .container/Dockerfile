# Container base
FROM debian:unstable-slim
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    hugo \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /app

# Hugo ports
EXPOSE 1313

# Interactively start
CMD ["hugo", "server", "-D", "--bind", "0.0.0.0"]
