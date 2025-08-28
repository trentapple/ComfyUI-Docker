# ComfyUI-Docker

A production-ready Docker container for [ComfyUI](https://github.com/comfyanonymous/ComfyUI), a powerful and modular stable diffusion GUI and backend with graph/nodes interface.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Building the Image](#building-the-image)
- [Running the Container](#running-the-container)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Security Considerations](#security-considerations)
- [Performance Optimization](#performance-optimization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This Docker image provides a containerized version of ComfyUI with the following benefits:

- **Production-ready**: Built with security best practices using non-root user
- **GPU acceleration**: CUDA 12.8 support with PyTorch optimizations
- **Modular architecture**: Clean separation of models, user data, and application code
- **Easy deployment**: Simple container orchestration with volume mounts
- **Cross-platform**: Works with Docker and Podman on Linux, macOS, and Windows

## Features

- 🐍 **Python 3.12** with optimized virtual environment
- 🚀 **PyTorch with CUDA 12.8** support for GPU acceleration  
- 🔒 **Security-first** design with non-root user execution
- 📁 **Persistent storage** for models, user data, and outputs
- 🌐 **Web interface** accessible on port 8188
- 🔄 **Auto-restart** capability for production deployments
- 📦 **Minimal base image** for reduced attack surface

## Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or Windows with WSL2
- **Container Runtime**: Docker (20.10+) or Podman (3.0+)
- **Memory**: 8GB RAM minimum, 16GB+ recommended
- **Storage**: 20GB+ free space for models and data
- **GPU** (optional but recommended): NVIDIA GPU with 6GB+ VRAM

### GPU Support Requirements

For GPU acceleration, you need:

- **NVIDIA GPU**: GTX 1060 6GB or better (RTX series recommended)
- **NVIDIA Drivers**: Version 470.57.02 or newer
- **Container Toolkit**: 
  - Docker: [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
  - Podman: [NVIDIA Container Support](https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html)

## Quick Start

1. **Clone ComfyUI source code**:
   ```bash
   git clone https://github.com/comfyanonymous/ComfyUI.git
   cd ComfyUI
   ```

2. **Clone this Docker repository**:
   ```bash
   git clone https://github.com/trentapple/ComfyUI-Docker.git
   ```

3. **Create required directories**:
   ```bash
   mkdir -p $HOME/ComfyUI/{models,user,output}
   ```

4. **Build the container**:
   ```bash
   docker build -t comfyui -f ../ComfyUI-Docker/Dockerfile .
   ```

5. **Run the container**:
   ```bash
   docker run -d --gpus all -p 8188:8188 --name comfyui \
     --restart unless-stopped \
     -v $HOME/ComfyUI/models:/app/models \
     -v $HOME/ComfyUI/user:/app/user \
     -v $HOME/ComfyUI/output:/app/output \
     comfyui
   ```

6. **Access ComfyUI**: Open http://localhost:8188 in your browser

## Building the Image

The build process must be run from within the ComfyUI source directory:

### Using Docker
```bash
cd /path/to/ComfyUI
docker build -t comfyui -f /path/to/ComfyUI-Docker/Dockerfile .
```

### Using Podman
```bash
cd /path/to/ComfyUI  
podman build -t localhost/comfyui -f /path/to/ComfyUI-Docker/Dockerfile .
```

### Build Arguments

The Dockerfile supports several build-time customizations:

```bash
# Use a different Python version
docker build --build-arg PYTHON_VERSION=3.11 -t comfyui .

# Customize virtual environment path
docker build --build-arg VIRTUAL_ENV=/opt/comfyui-venv -t comfyui .
```

## Running the Container

### Basic Usage

**Docker**:
```bash
docker run -d --gpus all -p 8188:8188 --name comfyui \
  --restart unless-stopped \
  -v $HOME/ComfyUI/models:/app/models \
  -v $HOME/ComfyUI/user:/app/user \
  comfyui
```

**Podman**:
```bash
podman run -d --device nvidia.com/gpu=all -p 8188:8188 --name comfyui \
  --restart unless-stopped \
  -v $HOME/ComfyUI/models:/app/models:Z \
  -v $HOME/ComfyUI/user:/app/user:Z \
  localhost/comfyui
```

### Advanced Usage

**With custom port and additional options**:
```bash
docker run -d --gpus all -p 8080:8188 --name comfyui \
  --restart unless-stopped \
  --memory="8g" \
  --cpus="4.0" \
  -v $HOME/ComfyUI/models:/app/models \
  -v $HOME/ComfyUI/user:/app/user \
  -v $HOME/ComfyUI/output:/app/output \
  -e COMFYUI_ARGS="--force-fp16 --lowvram" \
  comfyui
```

### Container Management

```bash
# View logs
docker logs comfyui

# Stop the container
docker stop comfyui

# Start the container
docker start comfyui

# Remove the container
docker rm comfyui

# Update the container
docker pull comfyui:latest
docker stop comfyui && docker rm comfyui
# Re-run with same options
```

## Configuration

### Volume Mounts

The container supports several volume mount points for data persistence:

| Host Path | Container Path | Purpose | Required |
|-----------|----------------|---------|----------|
| `$HOME/ComfyUI/models` | `/app/models` | Model files (checkpoints, LoRAs, etc.) | Yes |
| `$HOME/ComfyUI/user` | `/app/user` | User data and custom nodes | Yes |
| `$HOME/ComfyUI/output` | `/app/output` | Generated images and outputs | Recommended |
| `$HOME/ComfyUI/input` | `/app/input` | Input images for processing | Optional |

### Directory Structure

```
$HOME/ComfyUI/
├── models/
│   ├── checkpoints/     # Stable Diffusion models
│   ├── loras/          # LoRA models  
│   ├── vae/            # VAE models
│   ├── controlnet/     # ControlNet models
│   └── embeddings/     # Textual inversions
├── user/               # User data and settings
├── output/             # Generated images
└── input/              # Input images
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PYTHONDONTWRITEBYTECODE` | `1` | Prevents Python from writing .pyc files |
| `PYTHONUNBUFFERED` | `1` | Forces Python output to be unbuffered |
| `VIRTUAL_ENV` | `/opt/venv` | Python virtual environment path |
| `COMFYUI_ARGS` | None | Additional arguments for ComfyUI |

### Example with Environment Variables

```bash
docker run -d --gpus all -p 8188:8188 --name comfyui \
  -e COMFYUI_ARGS="--force-fp16 --lowvram --cpu" \
  -v $HOME/ComfyUI/models:/app/models \
  -v $HOME/ComfyUI/user:/app/user \
  comfyui
```

## Security Considerations

This Docker image follows security best practices:

- **Non-root execution**: Application runs as user `app` (not root)
- **Minimal base image**: Uses `python:3.12-slim` to reduce attack surface
- **HTTPS sources**: Package sources use HTTPS for integrity
- **No unnecessary privileges**: Container doesn't require privileged mode
- **Resource limits**: Consider setting memory and CPU limits in production

### Recommended Security Options

```bash
docker run -d --gpus all -p 127.0.0.1:8188:8188 \
  --security-opt=no-new-privileges:true \
  --read-only \
  --tmpfs /tmp \
  --memory="8g" \
  --cpus="4.0" \
  --name comfyui \
  comfyui
```

## Performance Optimization

### GPU Memory Management

For systems with limited VRAM:

```bash
# Low VRAM mode
docker run -d --gpus all -p 8188:8188 --name comfyui \
  -e COMFYUI_ARGS="--lowvram" \
  comfyui

# CPU fallback mode  
docker run -d --gpus all -p 8188:8188 --name comfyui \
  -e COMFYUI_ARGS="--cpu" \
  comfyui

# Force FP16 for memory savings
docker run -d --gpus all -p 8188:8188 --name comfyui \
  -e COMFYUI_ARGS="--force-fp16" \
  comfyui
```

### Storage Optimization

- Use fast SSD storage for model directory
- Consider using tmpfs for temporary files
- Regularly clean up output directory

## Troubleshooting

### Common Issues

**Container won't start with GPU support**:
- Verify NVIDIA Container Toolkit installation: `docker run --gpus all nvidia/cuda:11.0-base nvidia-smi`
- Check GPU drivers: `nvidia-smi`
- For Podman: Use `--device nvidia.com/gpu=all` instead of `--gpus all`

**Permission denied errors**:
- Ensure directories exist: `mkdir -p $HOME/ComfyUI/{models,user,output}`
- Check directory permissions: `ls -la $HOME/ComfyUI/`
- For SELinux systems (RHEL/CentOS), add `:Z` to volume mounts

**Out of memory errors**:
- Add `--lowvram` or `--cpu` to COMFYUI_ARGS
- Increase container memory limit: `--memory="16g"`
- Close other GPU applications

**Models not loading**:
- Verify model files are in correct subdirectories
- Check volume mount paths in `docker inspect comfyui`
- Ensure models are compatible with ComfyUI version

**Connection issues**:
- Verify port mapping: `docker port comfyui`
- Check firewall settings
- For remote access, bind to `0.0.0.0:8188:8188` instead of `127.0.0.1:8188:8188`

### Debug Mode

Run container in interactive mode for debugging:

```bash
docker run -it --gpus all -p 8188:8188 \
  -v $HOME/ComfyUI/models:/app/models \
  -v $HOME/ComfyUI/user:/app/user \
  comfyui /bin/bash
```

### Logs and Monitoring

```bash
# View real-time logs
docker logs -f comfyui

# Check container resource usage
docker stats comfyui

# Inspect container configuration
docker inspect comfyui
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/improvement`
3. Make your changes and test thoroughly
4. Submit a pull request with detailed description

### Development Setup

For local development and testing:

```bash
# Build development image
docker build -t comfyui:dev -f Dockerfile .

# Run with development mounts
docker run -it --gpus all -p 8188:8188 \
  -v $(pwd):/app \
  comfyui:dev /bin/bash
```

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

ComfyUI is licensed under GPL-3.0. This Docker configuration inherits that license.
