# syntax=docker/dockerfile:1.9
FROM python:3.12-slim

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

# Create non-root user
RUN if ! id -u app >/dev/null 2>&1; then \
      useradd -rUM -s /usr/sbin/nologin app; \
    fi

# Set environment variables for running the app
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="${VIRTUAL_ENV:-/opt/venv}/bin:${PATH}"

# Copy project files for dependency installation (better caching)
COPY pyproject.toml requirements.txt ./

# Install dependencies (with cache layer) -- NOTE: the pip install --pre torch ... line allows for newer CUDA version
RUN --mount=type=cache,target=/root/.cache python -m venv ${VIRTUAL_ENV:-/opt/venv} && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install --upgrade && \
    ${VIRTUAL_ENV:-/opt/venv}/bin/pip install -r requirements.txt

# Change ownership of paths to app:app
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Copy application
COPY --chown=app:app . /app/

# Expose port
EXPOSE 8188

# Command to run the application
CMD ["python", "main.py", "--listen", "0.0.0.0"]
