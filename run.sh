#!/bin/sh
export LLAMA_STACK_PORT=5051
podman run \
  -it \
  -p $LLAMA_STACK_PORT:$LLAMA_STACK_PORT \
  -v ./run.yaml:/tmp/run.yaml:Z \
  llamastack/distribution-remote-vllm \
  --yaml-config /tmp/run.yaml \
  --port $LLAMA_STACK_PORT \
  --env VLLM_MAX_TOKENS=6048 \
  --env LLAMA_STACK_CLIENT_LOG=debug \
  --env INFERENCE_MODEL=granite-3-8b-instruct \
  --env VLLM_URL=https://granite-3-8b-instruct-maas-apicast-production.apps.prod.rhoai.rh-aiservices-bu.com:443/v1 \
  --env VLLM_API_TOKEN=669946d4c84dc1f6dd512c033e17f9fb