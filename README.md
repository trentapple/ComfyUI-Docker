# ComfyUI-Docker
Docker / podman Dockerfile for ComfyUI

Run build command in the `ComfyUI` [source](https://github.com/comfyanonymous/ComfyUI) folder at desired version to build the image (may substitute docker for podman):

`podman build -t localhost/comfyui -f ../ComfyUI-Docker/Dockerfile .`

Running the container:

`podman run --replace -d --gpus all -p 8188:8188 --name ComfyUI --restart always --mount type=bind,source=$HOME/ComfyUI/models,target=/app/models,Z --mount type=bind,source=$HOME/ComfyUI/user,target=/app/user,Z localhost/comfyui`

*(requires [nvidia-container-toolkit](https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html) or similar NVIDIA / CUDA setup for containers)*

If you encounter a problem, the following may help troubleshoot:
 - verify the [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (or applicable hardware tooling) is installed and configured for use with docker or podman
 - check that the user data folder exists for the source bind mount command above: `mkdir -p $HOME/ComfyUI/user`
 - as an alternative to bind mounting the user directory, you may change the `--mount` for that path if you do not wish to persist a specific user directory
