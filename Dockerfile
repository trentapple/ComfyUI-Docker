# syntax=docker/dockerfile:1.9
FROM python:3.13-slim

WORKDIR /app

# Leverage HTTPS for apt sources (technically optional at least for integrity due to PGP keys, but preferred)
RUN sed -i 's/http:/https:/' /etc/apt/sources.list.d/debian.sources

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Privacy: opt out of HuggingFace Hub telemetry and honour the universal DO_NOT_TRACK signal
ENV HF_HUB_DISABLE_TELEMETRY=1 \
    DO_NOT_TRACK=1

# Create non-root user
RUN if ! id -u app >/dev/null 2>&1; then \
      useradd -rUM -s /usr/sbin/nologin app; \
    fi

# Set environment variables for running the app
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV:-/opt/venv}/bin:${PATH}"

# Copy project files for dependency installation (better caching)
COPY pyproject.toml requirements.txt ./

# Install dependencies (with cache layer) --pre torch ... allows for newer CUDA version
RUN --mount=type=cache,target=/root/.cache python -m venv ${VIRTUAL_ENV:-/opt/venv} && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install --upgrade pip && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130 && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install -r requirements.txt

# Change ownership of paths to app:app
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Copy application
COPY --chown=app:app . /app/

# Expose port
EXPOSE 8188

# Command to run the application.
#
# --listen 0.0.0.0      Required for Docker bridge networking; restrict host-side access via the
#                       published port and/or a reverse proxy rather than changing this value.
# --disable-auto-launch Suppresses the automatic browser-open that is irrelevant in a container.
# --disable-api-nodes   Prevents the frontend and API nodes from making outbound calls to
#                       external services (e.g. api.comfy.org), keeping the container
#                       network-quiet by default.
CMD ["python", "main.py", \
     "--listen", "0.0.0.0", \
     "--disable-auto-launch", \
     "--disable-api-nodes"]
