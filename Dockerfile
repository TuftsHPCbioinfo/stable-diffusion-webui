FROM siutin/stable-diffusion-webui-docker:cuda-12.0.0-v1.10.1-2025-02-10
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

USER root

ENV PATH=/app/miniconda3/bin:/app/stable-diffusion-webui:$PATH
ENV PYTHONPATH=/app/stable-diffusion-webui

# Native build deps needed by some ControlNet extras, especially pycairo/svglib
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      python3-dev \
      libcairo2-dev && \
    rm -rf /var/lib/apt/lists/*

# Install ControlNet in the supported extension location
RUN git clone https://github.com/Mikubill/sd-webui-controlnet.git \
    /app/stable-diffusion-webui/extensions/sd-webui-controlnet

WORKDIR /app/stable-diffusion-webui
RUN python extensions/sd-webui-controlnet/install.py

RUN chmod +x /app/stable-diffusion-webui/webui.sh

RUN git config --global --add safe.directory /app/stable-diffusion-webui && \
    git config --global --add safe.directory /app/stable-diffusion-webui/extensions/sd-webui-controlnet && \
    for d in /app/stable-diffusion-webui/repositories/*; do \
      git config --global --add safe.directory "$d"; \
    done