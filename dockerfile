# Dockerfile.blkwell
FROM ghcr.io/invoke-ai/invokeai:latest

USER root
# 1. Overwrite the stable wheels with the nightly CUDA-12.8 wheels (SM 120 kernels)
RUN uv pip install --upgrade --force-reinstall \
      torch torchvision torchaudio \
      --index=https://download.pytorch.org/whl/nightly/cu128

# 2. Replace /start.sh with a minimal entry-point that skips chown
RUN printf '#!/usr/bin/env bash\nsource /opt/venv/bin/activate\n'\
'export INVOKEAI_HOST=${INVOKEAI_HOST:-0.0.0.0}\n'\
'export INVOKEAI_PORT=${INVOKEAI_PORT:-9090}\n'\
'exec invokeai-web --root /invokeai\n' > /entrypoint.sh \
 && chmod +x /entrypoint.sh

# announce the port
EXPOSE 9090

ENTRYPOINT ["/entrypoint.sh"]
