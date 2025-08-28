# Contributing to ComfyUI-Docker

Thank you for your interest in contributing to ComfyUI-Docker! This document provides guidelines for contributing to this project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Code Style](#code-style)
- [Testing](#testing)

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/ComfyUI-Docker.git
   cd ComfyUI-Docker
   ```
3. **Create a branch** for your feature or fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Setup

### Prerequisites

- Docker or Podman
- Git
- A text editor or IDE
- ComfyUI source code for testing

### Local Testing

1. **Clone ComfyUI** for testing:
   ```bash
   git clone https://github.com/comfyanonymous/ComfyUI.git
   cd ComfyUI
   ```

2. **Build your modified Docker image**:
   ```bash
   docker build -t comfyui:dev -f /path/to/your/ComfyUI-Docker/Dockerfile .
   ```

3. **Test the image**:
   ```bash
   docker run --rm -p 8188:8188 comfyui:dev
   ```

## Contributing Guidelines

### Types of Contributions

We welcome several types of contributions:

- **Bug fixes** - Fix issues with the Dockerfile or documentation
- **Feature enhancements** - Improve the Docker configuration
- **Documentation improvements** - Enhance README, add examples, fix typos
- **Security improvements** - Enhance container security
- **Performance optimizations** - Improve build time or runtime performance

### Before You Start

- **Check existing issues** - Look for related issues or discussions
- **Open an issue** - For significant changes, discuss your idea first
- **Keep changes focused** - One feature or fix per pull request
- **Test thoroughly** - Ensure your changes work as expected

## Pull Request Process

1. **Update documentation** - Update README.md if your changes affect usage
2. **Test your changes** - Build and run the container to verify functionality
3. **Write clear commit messages** - Use descriptive commit messages
4. **Keep commits atomic** - Each commit should represent one logical change
5. **Update changelog** - Add your changes to the changelog if applicable

### Commit Message Format

Use clear, descriptive commit messages:

```
type: Brief description of change

Longer description if needed explaining what changed and why.

Fixes #issue-number
```

Types:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `security:` - Security improvements
- `perf:` - Performance improvements
- `refactor:` - Code refactoring

### Example Commit Messages

```
feat: Add support for custom PyTorch index URL

Allow users to specify a custom PyTorch index URL during build
for compatibility with different CUDA versions.

docs: Update README with volume mount best practices

Add detailed explanation of volume mounts and security
considerations for production deployments.

fix: Resolve permission issues with user directory

Ensure app user has proper permissions for mounted volumes
by adjusting Dockerfile ownership commands.
```

## Reporting Issues

When reporting issues, please include:

### For Bug Reports

- **Docker/Podman version**: `docker --version`
- **Operating system**: Linux distro, macOS version, or Windows version
- **GPU information**: `nvidia-smi` output if using GPU
- **Error messages**: Full error output or logs
- **Steps to reproduce**: Exact commands used
- **Expected behavior**: What should have happened
- **Actual behavior**: What actually happened

### For Feature Requests

- **Use case**: Describe why this feature would be useful
- **Proposed solution**: How you think it should work
- **Alternatives considered**: Other approaches you've thought about
- **Implementation details**: Technical considerations if you have them

## Code Style

### Dockerfile Best Practices

- **Layer caching**: Order instructions to maximize cache reuse
- **Minimal layers**: Combine related RUN commands
- **Security**: Use non-root user, pin versions, verify signatures
- **Documentation**: Comment complex or non-obvious instructions
- **Multi-platform**: Consider compatibility with different architectures

### Documentation Style

- **Clear headings**: Use descriptive section headers
- **Code blocks**: Use proper syntax highlighting
- **Examples**: Provide working examples for all instructions
- **Links**: Keep external links up to date
- **Consistency**: Follow the existing documentation style

## Testing

### Manual Testing Checklist

Before submitting a pull request, test the following:

- [ ] **Build succeeds**: `docker build` completes without errors
- [ ] **Container starts**: `docker run` starts the container successfully
- [ ] **Web interface loads**: ComfyUI web interface is accessible
- [ ] **GPU support works**: CUDA functionality works if applicable
- [ ] **Volume mounts work**: Persistent data is properly mounted
- [ ] **Permissions correct**: No permission errors in logs
- [ ] **Documentation accurate**: README instructions work as described

### Testing Different Scenarios

Test your changes with:

- **Different Docker versions**: Test on supported Docker versions
- **With and without GPU**: Test both GPU and CPU-only scenarios
- **Different operating systems**: Test on Linux, macOS, and Windows if possible
- **Various volume configurations**: Test different mount options

## Security Considerations

When contributing, consider:

- **Dependency updates**: Keep base images and packages current
- **Vulnerability scanning**: Check for known security issues
- **Privilege escalation**: Avoid unnecessary privileges
- **Secret handling**: Don't include secrets in the image
- **Network security**: Consider network access requirements

## Community Guidelines

- **Be respectful**: Treat all community members with respect
- **Be patient**: Allow time for review and feedback
- **Be collaborative**: Work together to find the best solutions
- **Be constructive**: Provide helpful feedback and suggestions

## Questions?

If you have questions about contributing:

- **Check the README**: Review the main documentation first
- **Search issues**: Look for similar questions in existing issues
- **Open an issue**: Create a new issue for specific questions
- **Be specific**: Provide context and details for better help

Thank you for contributing to ComfyUI-Docker!