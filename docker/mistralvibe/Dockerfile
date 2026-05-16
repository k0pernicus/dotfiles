FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends bash ca-certificates curl git && \
    rm -rf /var/lib/apt/lists/*

# Set working directory and path for root
WORKDIR /root
ENV PATH="/root/.local/bin:$PATH"

# Install Mistral Vibe directly as root
RUN curl -LsSf https://mistral.ai/vibe/install.sh | bash

CMD ["vibe"]
