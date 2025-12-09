# Container base
FROM debian:unstable-slim
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    hugo \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /app

# Hugo ports
EXPOSE 1313

# Start the container
CMD ["hugo", "server", "-D", "--bind", "0.0.0.0"]
