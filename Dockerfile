# syntax=docker/dockerfile:1.9
FROM python:3.12-slim

WORKDIR /app

# Leverage HTTPS for apt sources (technically optional at least for integrity due to PGP keys, but preferred)
RUN sed -i 's/http:/https:/' /etc/apt/sources.list.d/debian.sources

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for running the app and DISABLE TELEMETRY
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HF_HUB_DISABLE_TELEMETRY=1 \
    DO_NOT_TRACK=1 \
    DISABLE_TELEMETRY=1 \
    TELEMETRY_DISABLED=1 \
    NO_ANALYTICS=1 \
    ANALYTICS_DISABLED=1 \
    HUGGINGFACE_HUB_DISABLE_TELEMETRY=1 \
    TRANSFORMERS_OFFLINE=1 \
    TORCH_TELEMETRY_DISABLED=1

# Create non-root user
RUN if ! id -u app >/dev/null 2>&1; then \
      useradd -rUM -s /usr/sbin/nologin app; \
    fi

# Set environment variables for virtual environment
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV:-/opt/venv}/bin:${PATH}"

# Copy project files for dependency installation (better caching)
COPY pyproject.toml requirements.txt ./

# Install dependencies (with cache layer) --pre torch ... allows for newer CUDA version
RUN --mount=type=cache,target=/root/.cache python -m venv ${VIRTUAL_ENV:-/opt/venv} && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install --upgrade pip && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128 && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install -r requirements.txt

# Copy telemetry override and modified main.py before changing ownership
COPY telemetry_override.py main.py ./

# Change ownership of paths to app:app
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Clone ComfyUI and copy our modified files over the originals
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /tmp/ComfyUI && \
    cp -r /tmp/ComfyUI/* /app/ && \
    rm -rf /tmp/ComfyUI && \
    # Override with our telemetry-disabled versions
    cp /app/telemetry_override.py /app/telemetry_override.py && \
    cp /app/main.py /app/main.py

# Copy any additional application files (if they exist)
COPY --chown=app:app . /app/

# Expose port
EXPOSE 8188

# Command to run the application
CMD ["python", "main.py", "--listen", "0.0.0.0"]
