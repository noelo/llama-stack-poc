
# Create the stack definition
```
LLAMA_STACK_CONFIG_DIR=/home/noelo/dev/llama-stack-poc llama stack build --image-type container
```

# change the base image 

```
version: 2
distribution_spec:
  description: mcp test image
  container_image: "registry.access.redhat.com/ubi9"
```

# Add extra pacakges as required
```
additional_pip_packages:
- mcp
- blobfile
- sqlalchemy[asyncio]
- pymilvus

```

# Build the image
```
export CONTAINER_BINARY=podman

llama stack build --config /home/noelo/dev/llama-stack-poc/distributions/llamastack-llsmcp/llamastack-llsmcp-build.yaml --image-type container --image-name llsmcp
```

# Tag and Push
```
podman tag localhost/llsmcp:0.2.15 quay.io/noeloc/llsmcp:latest

podman tag localhost/llsmcp:0.2.15 quay.io/noeloc/llsmcp:latest
```

# fill out the CR and apply
```
apiVersion: llamastack.io/v1alpha1
kind: LlamaStackDistribution
metadata:
  name: llsmcp
spec:
  replicas: 1
  server:
    containerSpec:
      env:
        - name: VLLM_TLS_VERIFY
          value: 'false'
        - name: VLLM_MAX_TOKENS
          value: '6000'
        - name: LLAMA_STACK_CLIENT_LOG
          value: debug 
        - name: INFERENCE_MODEL
          value: 'microsoft/phi-4'
        - name: VLLM_DEBUG_LOG_API_SERVER_RESPONSE
          value: 'true' 
        - name: VLLM_URL
          value: https://phi-4-maas-apicast-production.apps.prod.rhoai.test.com:443/v1
        - name: VLLM_API_TOKEN
          value: 123
        - name: MILVUS_DB_PATH
          value: /home/lls/.lls/milvus.db
      name: llama-stack
    distribution:
      image: quay.io/noeloc/llsmcp:latest
    storage:
      size: "20Gi"
      mountPath: "/home/lls/.lls"  # Optional, defaults to /.llama. Use with custom distribution images that have a different setup.
```