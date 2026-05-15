FROM debian:bookworm-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends bash ca-certificates curl git && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 vibe && useradd -u 1000 -g vibe -m -s /bin/bash vibe

RUN mkdir -p /home/vibe/.vibe /home/vibe/.local /home/vibe/.config && chown -R vibe:vibe /home/vibe

USER vibe
WORKDIR /home/vibe
ENV PATH="/home/vibe/.local/bin:$PATH"
RUN curl -LsSf https://mistral.ai/vibe/install.sh | bash

CMD ["vibe"]
