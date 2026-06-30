# ComfyUI-Docker
Docker / podman Dockerfile for ComfyUI

Run build command in the `ComfyUI` [source](https://github.com/comfyanonymous/ComfyUI) folder at desired version to build the image (may substitute `podman` for `docker`):

`podman build -t localhost/comfyui -f ../ComfyUI-Docker/Dockerfile .`

Running the container:

`podman run --replace -d --gpus all -p 8188:8188 --name ComfyUI --restart always --mount type=bind,source=$HOME/ComfyUI/models,target=/app/models,Z -v $HOME/ComfyUI/user:/app/user:rw,Z localhost/comfyui`

*(requires [nvidia-container-toolkit](https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html) or similar NVIDIA / CUDA setup for containers)*

## Security and Privacy

The image is built with several security and privacy defaults:

- **Non-root user** — the server runs as an unprivileged `app` user inside the container.
- **HTTPS apt sources** — package downloads use HTTPS even within the image build.
- **`HF_HUB_DISABLE_TELEMETRY=1`** and **`DO_NOT_TRACK=1`** — environment variables that signal to Hugging Face Hub and other libraries that respect the [Do Not Track](https://www.eff.org/issues/do-not-track) convention not to phone home.
- **`--disable-api-nodes`** — prevents ComfyUI from loading API nodes that make outbound calls to external services (e.g. `api.comfy.org`) and suppresses matching frontend network activity. Remove this flag if you intentionally use API-backed nodes.
- **`--disable-auto-launch`** — suppresses the automatic browser launch that is irrelevant in a headless container.
- **`--listen 0.0.0.0`** — required for Docker bridge networking. Restrict access at the host by only publishing the port to `127.0.0.1` (e.g. `-p 127.0.0.1:8188:8188`) and placing a reverse proxy with authentication and TLS in front of it if the host is reachable from untrusted networks.

### Additional privacy flags (override CMD as needed)

| Flag | Effect |
|---|---|
| `--disable-metadata` | Do not embed prompt/workflow metadata into generated image files. |
| `--front-end-version comfyanonymous/ComfyUI@<version>` | Pin the bundled frontend to a specific version and avoid fetching updates from GitHub at startup. |

To pass additional flags, override the command at runtime:

```
podman run ... localhost/comfyui python main.py --listen 0.0.0.0 --disable-auto-launch --disable-api-nodes --disable-metadata
```

## Troubleshooting

If you encounter a problem, the following may help troubleshoot:
 - verify the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (or applicable hardware tooling) is installed and configured for use with docker or podman
 - check that the user data folder exists for the source bind mount command above: `mkdir -p $HOME/ComfyUI/user`
 - as an alternative to bind mounting the user directory, you may change the `--mount` for that path if you do not wish to persist a specific user directory
