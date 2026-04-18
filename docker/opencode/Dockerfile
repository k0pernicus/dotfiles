# Start from the exact Alpine-based OpenCode image
FROM ghcr.io/anomalyco/opencode:1.4.3

# Switch to root temporarily to install packages and create the user
USER root

# Use apk to install bash, curl, Python, pip, Go, and rustup
RUN apk update && apk add --no-cache \
    bash \
    curl \
    python3 \
    py3-pip \
    go \
    rustup

# Create a non-root user named 'opencode' with UID 1000
RUN addgroup -g 1000 opencode && \
    adduser -D -u 1000 -G opencode -s /bin/bash opencode

# Pre-create the necessary directories so Docker doesn't make them as root
RUN mkdir -p /home/opencode/.config/opencode \
             /home/opencode/.local/share/opencode \
             /home/opencode/.local/state && \
    chown -R opencode:opencode /home/opencode

# Switch to the new, non-root user
USER opencode
