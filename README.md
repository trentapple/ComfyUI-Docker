# ComfyUI-Docker (No Telemetry Fork)

🚫 **Telemetry-Free Version** - This fork completely disables all telemetry and analytics in ComfyUI

Docker / podman Dockerfile for ComfyUI with comprehensive telemetry disabling.

## 🔒 Privacy Features

This fork ensures complete telemetry disabling through:

- ✅ **Environment Variables**: Sets all known telemetry-disabling environment variables
- ✅ **Modified main.py**: Enhanced telemetry blocking in the main entry point  
- ✅ **Telemetry Override Script**: Custom Python script that no-ops all telemetry functions
- ✅ **Import Patching**: Monkey patches telemetry modules to prevent any data collection
- ✅ **Build-time Protection**: Telemetry disabled at Docker build time

### Disabled Telemetry Sources
- HuggingFace Hub telemetry (`HF_HUB_DISABLE_TELEMETRY=1`)
- General tracking (`DO_NOT_TRACK=1`)
- Transformers library analytics
- PyTorch telemetry
- All custom node analytics

## 🚀 Quick Start

### Using Pre-built Images (Recommended)

Pull the latest telemetry-free image from GitHub Container Registry:

```bash
docker pull ghcr.io/trentapple/comfyui-docker/comfyui-no-telemetry:latest
```

Run the container:

```bash
docker run --replace -d --gpus all -p 8188:8188 --name ComfyUI --restart always \
  --mount type=bind,source=$HOME/ComfyUI/models,target=/app/models,Z \
  -v $HOME/ComfyUI/user:/app/user:rw,Z \
  ghcr.io/trentapple/comfyui-docker/comfyui-no-telemetry:latest
```

### Building Locally

Clone this repository and build:

```bash
git clone https://github.com/trentapple/ComfyUI-Docker.git
cd ComfyUI-Docker
docker build -t localhost/comfyui-no-telemetry .
```

Run locally built image:

```bash
docker run --replace -d --gpus all -p 8188:8188 --name ComfyUI --restart always \
  --mount type=bind,source=$HOME/ComfyUI/models,target=/app/models,Z \
  -v $HOME/ComfyUI/user:/app/user:rw,Z \
  localhost/comfyui-no-telemetry
```

## 🔧 System Requirements

- **GPU Support**: NVIDIA GPU with CUDA support recommended
- **Container Runtime**: Docker or Podman with GPU support
- **nvidia-container-toolkit**: Required for GPU access ([installation guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html))

## 📁 Directory Structure

Create necessary directories before running:

```bash
mkdir -p $HOME/ComfyUI/models
mkdir -p $HOME/ComfyUI/user
```

## 🛠️ Troubleshooting

If you encounter problems:

- Verify [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) is installed and configured
- Ensure user data folders exist: `mkdir -p $HOME/ComfyUI/user`
- For persistence alternatives, modify the `--mount` paths as needed

## 🔍 Verification

To verify telemetry is disabled, check the container logs when starting:

```bash
docker logs ComfyUI
```

You should see messages confirming telemetry is disabled.

## 📋 Environment Variables Set

This image automatically sets these environment variables to disable telemetry:

```env
HF_HUB_DISABLE_TELEMETRY=1
DO_NOT_TRACK=1
DISABLE_TELEMETRY=1
TELEMETRY_DISABLED=1
NO_ANALYTICS=1
ANALYTICS_DISABLED=1
HUGGINGFACE_HUB_DISABLE_TELEMETRY=1
TRANSFORMERS_OFFLINE=1
TORCH_TELEMETRY_DISABLED=1
```

## 🏗️ Build Status

![Build Status](https://github.com/trentapple/ComfyUI-Docker/actions/workflows/build-docker.yml/badge.svg)

Automated builds are triggered on:
- Push to main branch
- Pull requests
- Weekly schedule (to ensure up-to-date base images)
- Manual workflow dispatch

## 📜 License

This project maintains the same license as the original ComfyUI project. See [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Original ComfyUI**: [comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- **Original Docker Repo**: [trentapple/ComfyUI-Docker](https://github.com/trentapple/ComfyUI-Docker)
- **Container Registry**: [ghcr.io packages](https://github.com/trentapple/ComfyUI-Docker/pkgs/container/comfyui-no-telemetry)
