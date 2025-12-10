set quiet

# Deploy an ephemeral container
_default:
    just venv-build
    just venv-run

# Build the container
venv-build:
    podman build -t \
        "$(basename "$PWD"):latest" \
        .container

# Run created container
venv-run:
    podman run -it --rm \
        -p 1313:1313 \
        -v "$(pwd)":/work:Z \
        -w /work "$(basename "$PWD"):work"
