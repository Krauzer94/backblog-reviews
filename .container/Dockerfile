# Container base
FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    hugo

# Working directory
WORKDIR /app

# Hugo ports
EXPOSE 1313

# Start the container
CMD [ "hugo", "server", "-D", "--bind", "0.0.0.0" ]
