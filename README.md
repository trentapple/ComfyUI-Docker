# ComfyUI-Docker
Docker / podman Dockerfile for ComfyUI

Run build command in the `ComfyUI` [source](https://github.com/comfyanonymous/ComfyUI) folder at desired version to build the image (may substitute `podman` for `docker`):

`podman build -t localhost/comfyui -f ../ComfyUI-Docker/Dockerfile .`

Running the container:

`podman run --replace -d --gpus all -p 8188:8188 --name ComfyUI --restart always --mount type=bind,source=$HOME/ComfyUI/models,target=/app/models,Z -v $HOME/ComfyUI/user:/app/user:rw,Z localhost/comfyui`

*(requires [nvidia-container-toolkit](https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html) or similar NVIDIA / CUDA setup for containers)*

## Security and Privacy

The image runs as a non-root user and sets `HF_HUB_DISABLE_TELEMETRY=1` and `DO_NOT_TRACK=1` to opt out of library telemetry. The default command includes `--disable-api-nodes` (prevents outbound calls to external API services; remove if you use API-backed nodes) and `--disable-auto-launch`. `--listen 0.0.0.0` is required for Docker bridge networking — restrict host-side exposure via the published port or a reverse proxy.

## Troubleshooting

If you encounter a problem, the following may help troubleshoot:
 - verify the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (or applicable hardware tooling) is installed and configured for use with docker or podman
 - check that the user data folder exists for the source bind mount command above: `mkdir -p $HOME/ComfyUI/user`
 - as an alternative to bind mounting the user directory, you may change the `--mount` for that path if you do not wish to persist a specific user directory
