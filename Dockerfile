FROM siutin/stable-diffusion-webui-docker:cuda-12.0.0-v1.10.1-2025-02-10
LABEL maintainer="Yucheng Zhang: Yucheng.Zhang@tufts.edu"

ENV PATH /app/miniconda3/bin/:/app/stable-diffusion-webui:$PATH


RUN chmod +x /app/stable-diffusion-webui/webui.sh

RUN for d in /app/stable-diffusion-webui/repositories/*; do \
      git config --global --add safe.directory "$d"; \
    done
