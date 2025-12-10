set quiet

# Deploy an ephemeral container
_default:
    just build
    just run

# Build the container
build:
    podman build -t \
        "$(basename "$PWD"):latest" \
        .container

# Run created container
run:
    podman run -it --rm \
        -p 1313:1313 \
        -v "$(pwd)":/work:Z \
        -w /work "$(basename "$PWD"):work"
