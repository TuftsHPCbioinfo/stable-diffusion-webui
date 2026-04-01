FROM siutin/stable-diffusion-webui-docker:cuda-12.0.0-v1.10.1-2025-02-10
LABEL maintainer="Yucheng Zhang <Yucheng.Zhang@tufts.edu>"

USER root

ENV PATH=/app/miniconda3/bin:/app/stable-diffusion-webui:$PATH
ENV PYTHONPATH=/app/stable-diffusion-webui

# Native deps needed by some ControlNet extras
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      python3-dev \
      libcairo2-dev && \
    rm -rf /var/lib/apt/lists/*

# Install ControlNet into the built-in extensions directory
RUN git clone https://github.com/Mikubill/sd-webui-controlnet.git \
    /app/stable-diffusion-webui/extensions/sd-webui-controlnet

WORKDIR /app/stable-diffusion-webui

# Make git happy inside container
RUN git config --global --add safe.directory /app/stable-diffusion-webui && \
    git config --global --add safe.directory /app/stable-diffusion-webui/extensions/sd-webui-controlnet && \
    for d in /app/stable-diffusion-webui/repositories/*; do \
      git config --global --add safe.directory "$d"; \
    done

# Run ControlNet installer inside the exact webui venv
RUN /app/stable-diffusion-webui/venv/bin/python extensions/sd-webui-controlnet/install.py

# Extra safety: install the package that your logs showed missing
RUN /app/stable-diffusion-webui/venv/bin/python -m pip install --no-cache-dir controlnet_aux

# Optional but commonly useful for some preprocessors
# Uncomment only if you need it
# RUN /app/stable-diffusion-webui/venv/bin/python -m pip install --no-cache-dir insightface

RUN chmod +x /app/stable-diffusion-webui/webui.sh
WORKDIR /app/stable-diffusion-webui